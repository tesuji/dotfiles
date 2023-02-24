#!/bin/sh
# -----------------------------------------------------------------------------
# WARNING:
#   This script may destroy your disk and kick your dog.
# -----------------------------------------------------------------------------

# Exit immediately if fail
set -e

HERE_DIR="$( cd "$(dirname "$0")" && pwd -P )"

do_disable_ipv6() {
  for conf in 'net.ipv6.conf.all.disable_ipv6' \
      'net.ipv6.conf.default.disable_ipv6' \
      'net.ipv6.conf.lo.disable_ipv6'; do
    if [ "$(sysctl -n "${conf}")" -eq 0 ]; then
      printf '%s = 1\n' "${conf}" | sudo tee -a '/etc/sysctl.conf' > /dev/null
    fi
  done

  if ! grep -q '^#::1' /etc/hosts; then
    sudo sed -i -E 's@^(::1)@#\1@g' /etc/hosts
  fi
}

set_no_enc_ath9k() {
  printf 'options ath9k nohwcrypt=1\n' \
    | sudo tee -a /etc/modprobe.d/ath9k.conf > /dev/null
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
    && sudo cp -f "${NEW_FSTAB}" "$FSTAB"
}

# Usage: set_passwd_grub <PBKDF2 hash>
# Set password to protect GRUB menu
#
# NOTE:
#   - Use "grub-mkpasswd-pbkdf2" to get PBKDF2 hash.
set_passwd_grub() {
  [ "$#" -ne 1 ] && return 1
  PBKDF2_HASH="$1"
  GRUB_CONF_DIR=/etc/grub.d
  GRUB_CUSTOM_CONF="$GRUB_CONF_DIR/40_custom"
  GRUB_LINUX_CONF="$GRUB_CONF_DIR/10_linux"

  printf 'set superusers="root"\npassword_pbkdf2 root %s\n' "${PBKDF2_HASH}" \
    | sudo tee -a "$GRUB_CUSTOM_CONF" > /dev/null

  if ! grep -q -F -- '--unrestricted' "$GRUB_LINUX_CONF"; then
    sudo sed -i -E \
        's@^\s*(echo "menuentry \x27\$\(echo "\$\w+" \| grub_quote\))@\1 --unrestricted@g' \
        "$GRUB_LINUX_CONF"
  fi
}

keep_app_state_in_RAM() {
  SYSCTL_CONF=/etc/sysctl.d/99-sysctl.conf

  if [ "$(sysctl -n vm.swappiness)" -eq 1 ] \
        || grep -q 'vm.swappiness=1' "$SYSCTL_CONF"; then
    return 0
  fi

  sudo tee -a "$SYSCTL_CONF" << EOF > /dev/null
vm.swappiness=1
vm.vfs_cache_pressure=50
vm.dirty_background_bytes=16777216
vm.dirty_bytes=50331648
EOF
  sudo sysctl -p "$SYSCTL_CONF"
}

disable_download_apt_translation() {
  APT_CONF_DIR=/etc/apt/apt.conf.d
  APT_TRANS_CONF="${APT_CONF_DIR}/99translations"
  UPDATE_NOTIFIER_CONF="${APT_CONF_DIR}/99update-notifier"
  APT_LIST_DIR=/var/lib/apt/lists/

  if ! grep -qR '^Acquire::Languages\s+"none"' "${APT_CONF_DIR}"; then
    printf 'Acquire::Languages "none";\n' | sudo tee -a "${APT_TRANS_CONF}" > /dev/null
    find "$APT_LIST_DIR" -name '*i18n*' -delete
  fi

  sed -i -E 's@^(DPkg::Post-Invoke)@#\1@g' "${UPDATE_NOTIFIER_CONF}"
}

# Reduce boot time and unnecessary auto services.
# Remove graphical package manager.
# Do update manually.
# Ref: https://askubuntu.com/a/880520/565006
disable_auto_update() {
  status="$(systemctl is-enabled apt-daily.timer)"
  rt_code="$?"
  [ "$status" = disable ] && [ "$rt_code" -gt 0 ] && return 0
  sudo apt-get purge -y software-center appstream snapd cups
  # or dpkg-divert --local --rename --divert '/etc/apt/apt.conf.d/#50appstream' /etc/apt/apt.conf.d/50appstream
  sudo systemctl stop motd-news.timer apt-daily.timer apt-daily-upgrade.timer
  sudo systemctl disable motd-news.timer apt-daily.timer apt-daily-upgrade.timer
}

# Remove English variant locale (not en_US)
# Ref https://serverfault.com/a/606666/448787
# https://www.linuxquestions.org/questions/blog/bittner-195120/remove-unwanted-locales-on-ubuntu-debian-3281/
# NOTE: On Ubuntu 18, do purge language-pack-en-base is enough.
purge_unneeded_locale() {
  set -e
  LC_ALL='C.UTF-8'
  export LC_ALL

  sudo apt-get purge -y language-pack-en-base

  readonly prefer_lang='en_US.UTF-8'
  readonly prefer_locale='en_US.UTF-8 UTF-8'

  sudo find /usr/lib/locale -mindepth 1 -delete
  sudo /usr/sbin/update-locale LANG="$prefer_lang"
  sudo find /var/lib/locales/supported.d -type f ! -name 'local' -delete
  printf '%s\n' "$prefer_locale" \
    | sudo tee /var/lib/locales/supported.d/local > /dev/null
  sudo locale-gen --purge
  set +e
}

. "$HERE_DIR/../ifmain.sh"

if ifmain; then
  keep_app_state_in_RAM
  disable_download_apt_translation
  disable_auto_update
fi
