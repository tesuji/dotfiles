#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# This script for installing Firefox Quantumn on Debian 9
# EXPERIMENTAL! Use at your own risk!
# ------------------------------------------------------------------------------

M_OUTFILE=''

ask_install() { # ask_install question
  printf '\n\n'
  read -r -p "$1 (y/N) " -n 1
  if printf '%s' "$REPLY" | grep -q '^[Yy]$'; then
    return 1
  else
    return 0
  fi
}

# Read Why does "local" sweep the return code of a command?
#    https://stackoverflow.com/a/4421282/5456794
download_firefox() {
  local ENTRY_URL DOWNLOAD_LOG FIREFOX_URL
  printf 'Testing firefox download link ...\n'
  ENTRY_URL='https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US'

  if DOWNLOAD_LOG=$(wget --spider "${ENTRY_URL}" 2>&1); then
    >&2 cat << EOF
Remote file does not exist -- broken link!!!
Exiting ...
EOF
    exit 2
  fi

  FIREFOX_URL=$(printf '%s' "${DOWNLOAD_LOG}" | grep Location | cut -d ' ' -f2)
  M_OUTFILE=$(basename "${FIREFOX_URL}")

  >&2 printf '[+] Download %s\n' "${M_OUTFILE}"

  case "${M_OUTFILE}" in
  "firefox"*".tar.bz2" )
    if ask_install 'Download this version ?'; then
      >&2 printf '%s\n' "Exitting ..."
      return 1
    fi

    wget --continue -O "${M_OUTFILE}" "${FIREFOX_URL}"
    ;;
  * )
    >&2 cat << EOF
It's NOT likely a tar.bz2 file ...
Exitting ...
EOF
    exit 1
    ;;
  esac
}

install_firefox() {
  local FIREFOX_BIN
  FIREFOX_BIN=/opt/firefox/firefox

  if ask_install 'Do you want to install ?'; then
    >&2 printf 'Unpacking firefox to /opt/ ...\n'
    sudo tar xjf --overwrite "${M_OUTFILE}" -C /opt/

    >&2 printf 'Setting owner and permissions (only this %s user) ...\n' "${USER}"
    sudo find /opt/firefox -exec chown "$USER". {} +
    sudo find /opt/firefox -type d -exec chmod 755 {} +

    # Ref: https://wiki.debian.org/Firefox
    >&2 printf 'Configuring alternative links to set Firefox be default browser ...\n'
    for BROWSER in {x-,gnome-,}www-browser; do
      sudo update-alternatives --install "/usr/bin/${BROWSER}" "${BROWSER}" "${FIREFOX_BIN}" 100
      sudo update-alternatives --set "${BROWSER}" "${FIREFOX_BIN}"
    done

    >&2 printf 'Creating symlink to /usr/bin/firefox\n'
    sudo ln -sf "${FIREFOX_BIN}" /usr/bin/firefox
  else
    return 1
  fi
}

remove_addons() {
  declare -a ADDONS_LIST=(
    'followonsearch@mozilla.com.xpi'
    'firefox@getpocket.com.xpi'
    'screenshots@mozilla.org.xpi'
  )

  >&2 printf 'Disabling addons %s ...\n' "${ADDONS_LIST[*]}"

  if ask_install 'Do you want to diable ?'; then
    for FILE in "${ADDONS_LIST[@]}"; do
      >&2 cat << EOF
[-] Disabling ${FILE} ...

EOF
      sudo chmod a-r "/opt/firefox/browser/features/${FILE}"
    done
  fi
}


download_firefox
install_firefox
remove_addons

unset M_OUTFILE
