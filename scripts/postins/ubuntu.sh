#!/bin/sh
# ------------------------------------------------------------------------------
# WARNING:
#   This script may destroy your disk and kick your dog.
# ------------------------------------------------------------------------------

# Exit immediately if fail
set -e

if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

do_disable_ipv6() {
  for conf in 'net.ipv6.conf.all.disable_ipv6' \
      'net.ipv6.conf.default.disable_ipv6' \
      'net.ipv6.conf.lo.disable_ipv6'; do
    if [ "$(sysctl -n "${conf}")" -eq 0 ]; then
      printf '%s = 1\n' "${conf}" >> '/etc/sysctl.conf'
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
  if grep -v '^#\S' /etc/fstab | grep '\s/\s' | grep -q 'noatime'; then
    return 0
  fi

  old_fstab="$(mktemp /tmp/fstab.XXXXXX)" \
  && new_fstab="$(mktemp /tmp/fstab.new.XXXXXX)" \
  && cp /etc/fstab "${old_fstab}" \
  && awk '!/^#/ && ($2=="/"){ $4=$4",noatime" }{ print }' OFS='\t' /etc/fstab > "${new_fstab}" \
  && cp "${new_fstab}" /etc/fstab
}

# Usage: set_option_fstab <PBKDF2 hash>
# Set password to protect GRUB menu
#
# NOTE:
#   - Use "grub-mkpasswd-pbkdf2" to get PBKDF2 hash.
set_passwd_grub() {
  [ "$#" -ne 1 ] && return 1

  PBKDF2_HASH=$1
  printf 'set superusers="root"\n' >> /etc/grub.d/40_custom
  printf 'password_pbkdf2 root %s\n' "${PBKDF2_HASH}" >> /etc/grub.d/40_custom

  if grep -q -- '--unrestricted' /etc/grub.d/10_linux; then
    return 1
  fi

  search_template='echo "menuentry '"'"'\$\(echo "\$\w+" \| grub_quote\)'"'"
  sed_cmd=$(printf 's@(%s)@\\1 --unrestricted@g' "${search_template}")
  sed -i -E "${sed_cmd}" /etc/grub.d/10_linux
}

keep_app_state_in_RAM() {
  [ "$(sysctl -n vm.swappiness)" -eq 1 ] && return 0

  cat << EOF >> /etc/sysctl.d/99-sysctl.conf
vm.swappiness=1
vm.vfs_cache_pressure=50
vm.dirty_background_bytes=16777216
vm.dirty_bytes=50331648
EOF
}

disable_download_apt_translation() {
  apt_dir=/etc/apt/apt.conf.d
  config_file="${apt_dir}/99translations"
  grep -qR 'Acquire::Languages "none"' "${apt_dir}" || return 1

  printf 'Acquire::Languages "none";\n' >> "${config_file}"
  find /var/lib/apt/lists/ -name '*i18n*' -delete
}

remove_cups_and_snap() {
  apt-get purge -y snapd cups
}

# Reduce boot time and unnecessary auto services.
# Do update manually.
disable_auto_update() {
  systemctl is-enabled apt-daily.timer && return 0
  systemctl stop motd-news.timer apt-daily.timer apt-daily-upgrade.timer
  systemctl disable motd-news.timer apt-daily.timer apt-daily-upgrade.timer
}
