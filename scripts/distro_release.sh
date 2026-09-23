#!/bin/sh

HERE_DIR="$( cd "$(dirname "$0")" && pwd -P )"

get_distro_info() {
  os_name=""
  os_ver=""
  # freedesktop.org and systemd
  if [ -r /etc/os-release ]; then
    os_name="$(grep '^NAME' /etc/os-release | cut -d '"' -f2)"
    os_ver="$(grep '^VERSION_ID' /etc/os-release | cut -d '"' -f2)"
  # linuxbase.org
  elif [ -x /usr/bin/lsb_release ]; then
    os_name="$(lsb_release -si)"
    os_ver="$(lsb_release -sr)"
  # For some versions of Debian/Ubuntu without lsb_release command
  elif [ -r /etc/lsb-release ]; then
    os_name="$(grep '^DISTRIB_ID' /etc/lsb-release | cut -d\" -f2)"
    os_ver="$(grep '^DISTRIB_RELEASE' /etc/lsb-release | cut -d\" -f2)"
  # Older Debian/Ubuntu/etc.
  elif [ -r /etc/debian_version ]; then
    os_name=Debian
    os_ver="$(cat /etc/debian_version)"
  # Older SuSE/etc.
  elif [ -r /etc/SuSE-release ]; then
    os_name="$(head -n1 /etc/SuSE-release)"
    os_ver="$(grep '^VERSION' /etc/SuSE-release | cut -d '=' -f2 | cut -d ' ' -f2)"
  # Older Red Hat, CentOS, etc.
  elif [ -r /etc/redhat-release ]; then
    os_name="Red Hat"
    os_ver="$(cut -d ' ' -f7 '/etc/redhat-release')"
  # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
  else
    os_name="$(uname -s)"
    os_ver="$(uname -r)"
  fi
  echo "${os_name}:${os_ver}"
}

. "$HERE_DIR/ifmain.sh"

if ifmain; then
  get_distro_info
fi

unset HERE_DIR
unset ifmain
