#! /bin/sh
# ------------------------------------------------------------------------------
# WARNING:
#   This script may destroy your disk and kick your dog.
# ------------------------------------------------------------------------------

# Exit immediately if fail
set -e

HERE_DIR="$( cd "$(dirname "$0")" && pwd -P )"

do_disable_ipv6() {
  for CONF in 'net.ipv6.conf.all.disable_ipv6' \
      'net.ipv6.conf.default.disable_ipv6' \
      'net.ipv6.conf.lo.disable_ipv6'; do
    if [ "$(sysctl -n "${CONF}")" -eq 0 ]; then
      printf '%s = 1\n' "${CONF}" >> '/etc/sysctl.conf'
    fi
  done

  if grep -q '^#::1' /etc/hosts; then
    return 0
  fi
  sed -i -E 's@^(::1)@#\1@g' /etc/hosts
}

set_no_enc_ath9k() {
  printf 'options ath9k nohwcrypt=1\n' >> /etc/modprobe.d/ath9k.conf
}

# Usage: set_option_fstab 'noatime'
# Set option for partitions in /etc/fstab
# NOTE:
#   * Require sudo
set_option_fstab() {
  if [ "$(awk '!/^#/ && ($2=="/"){ print index($4, "noatime") }' /etc/fstab)" -eq 0 ]; then
    return 0
  fi

  FSTAB=/etc/fstab
  OLD_FSTAB="$(mktemp /tmp/fstab.XXXXXX)" \
  && NEW_FSTAB="$(mktemp /tmp/fstab.new.XXXXXX)" \
  && cp "$FSTAB" "${OLD_FSTAB}" \
  && awk '!/^#/ && ($2=="/"){ $4=$4",noatime" }{ print }' OFS='\t' "$FSTAB" > "${NEW_FSTAB}" \
  && cp "${NEW_FSTAB}" "$FSTAB"
}

# Usage: set_option_fstab <PBKDF2 hash>
# Set password to protect GRUB menu
#
# NOTE:
#   - Use "grub-mkpasswd-pbkdf2" to get PBKDF2 hash.
set_passwd_grub() {
  [ "$#" -ne 1 ] && return 1
  PBKDF2_HASH=$1
  GRUB_CONF_DIR=/etc/grub.d
  GRUB_CUSTOM_CONF="$GRUB_CONF_DIR/40_custom"
  GRUB_LINUX_CONF="$GRUB_CONF_DIR/10_linux"

  printf 'set superusers="root"\npassword_pbkdf2 root %s\n' "${PBKDF2_HASH}" >> "$GRUB_CUSTOM_CONF"

  grep -q -F -- '--unrestricted' "$GRUB_LINUX_CONF" && return 0

  TEMPLATE="$(printf 'echo "menuentry \x27%s\x27' '\$\(echo "\$\w+" \| grub_quote\)')"
  SED_CMD="$(printf 's@(%s)@%s@g' "${TEMPLATE}" '\1 --unrestricted')"
  sed -i -E "${SED_CMD}" "$GRUB_LINUX_CONF"
}

keep_app_state_in_RAM() {
  [ "$(sysctl -n vm.swappiness)" -eq 1 ] && return 0

  SYSCTL_CONF=/etc/sysctl.d/99-sysctl.conf
  cat << EOF >> "$SYSCTL_CONF"
vm.swappiness=1
vm.vfs_cache_pressure=50
vm.dirty_background_bytes=16777216
vm.dirty_bytes=50331648
EOF
  sysctl -p "$SYSCTL_CONF"
}

disable_download_apt_translation() {
  APT_CONF_DIR=/etc/apt/apt.conf.d
  APT_TRANS_CONF="${APT_CONF_DIR}/99translations"
  APT_LIST_DIR=/var/lib/apt/lists/

  grep -qR '^Acquire::Languages\s+"none"' "${APT_CONF_DIR}" && return 0

  printf 'Acquire::Languages "none";\n' >> "${APT_TRANS_CONF}"
  find "$APT_LIST_DIR" -name '*i18n*' -delete
}

# Reduce boot time and unnecessary auto services.
# Remove graphical package manager.
# Do update manually.
# Ref: https://askubuntu.com/a/880520/565006
disable_auto_update() {
  RS="$(systemctl is-enabled apt-daily.timer)"
  CODE="$?"
  [ "$RS" = disable ] && [ "$CODE" -gt 0 ] && return 0
  apt-get purge -y software-center appstream snapd cups
  # or dpkg-divert --local --rename --divert '/etc/apt/apt.conf.d/#50appstream' /etc/apt/apt.conf.d/50appstream
  systemctl stop motd-news.timer apt-daily.timer apt-daily-upgrade.timer
  systemctl disable motd-news.timer apt-daily.timer apt-daily-upgrade.timer
}

. "$HERE_DIR/../ifmain.sh"

if ifmain; then
  keep_app_state_in_RAM
  disable_download_apt_translation
  disable_auto_update
fi
