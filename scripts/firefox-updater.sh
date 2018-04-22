#!/usr/bin/env bash
##########################################################
## This script for installing Firefox Quantumn on Debian 9
## EXPERIMENTAL! Use at your own risk!
##########################################################

_outfile=""

ask_install() { # ask_install question
  printf "\n\n"
  read -p "$1 (y/N) " -n 1
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    return 1
  else
    return 0
  fi
}

download_firefox() {
  echo "Testing firefox download link ..."
  local entry_url='https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US'
  local download_log=$(wget --spider "$entry_url" 2>&1)
  local isSucess=$?

  if [[ $isSucess -ne 0 ]]; then
    echo 'Remote file does not exist -- broken link!!!'
    echo "Exiting ..."
    exit $isSucess
  fi

  local firefox_url=$(echo "$download_log" | grep Location |cut -d ' ' -f2)
  _outfile=$(basename "$firefox_url")

  echo "[+] Download ${_outfile}"

  if [[ "${_outfile}" == "firefox"*".tar.bz2" ]]; then
    ask_install "Download this version ?"

    if [[ $? -eq 0 ]]; then
      echo "Exitting ..."
      return 1
    fi

    wget --continue -O "${_outfile}" "$firefox_url"
  else
    echo "It's NOT likely a tar.bz2 file ..."
    echo "Exitting ..."
    exit 1
  fi
}

install_firefox() {
  local firefox_bin=/opt/firefox/firefox
  ask_install "Do you want to install ?"

  if [[ $? -eq 1 ]]; then
    echo "Unpacking firefox to /opt/ ..."
    sudo tar xjf --overwrite "${_outfile}" -C /opt/

    echo "Setting owner and permissions (only this ${USER} user) ..."
    sudo find /opt/firefox -exec chown "$USER". {} +
    sudo find /opt/firefox -type d -exec chmod 755 {} +

    # Ref: https://wiki.debian.org/Firefox
    echo "Configuring alternative links to set Firefox be default browser ..."
    for browser in {x-,gnome-,}www-browser; do
      sudo update-alternatives --install "/usr/bin/${browser}" "${browser}" "$firefox_bin" 100
      sudo update-alternatives --set "${browser}" "$firefox_bin"
    done

    echo "Creating symlink to /usr/bin/firefox"
    sudo ln -sf "$firefox_bin" /usr/bin/firefox
  else
    return 1
  fi
}

remove_addons() {
  declare -a addons_list=(
      "followonsearch@mozilla.com.xpi"
      "firefox@getpocket.com.xpi"
      "screenshots@mozilla.org.xpi"
      )
  echo "Disabling addons ${addons_list[@]} ..."

  ask_install "Do you want to diable ?"

  if [[ $? -eq 1 ]]; then
    for file in "${addons_list[@]}"; do
      echo "[-] Disabling ${file} ...\n"
      sudo chmod a-r "/opt/firefox/browser/features/${file}"
    done
  fi
}


download_firefox
install_firefox
remove_addons

unset _outfile
