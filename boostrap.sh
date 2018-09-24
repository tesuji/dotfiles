#!/usr/bin/env bash
#######################################################
# This script is used to installing some useful program
# Only testing for Arch and Debian Linux
# Use at your own risk!
#######################################################

###########
# Functions
###########

# Check if command exists
check_exist() { # check_exist name
  # POSIX compatible, not with `hash', `type', etc.
  command -v "$1" > /dev/null
}

## Ask for installing, default is No
ask_install() { # ask_install question
  echo
  read -r -p "$1 (y/N) " -n 1
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    return 1
  else
    return 0
  fi
}

# Install sublime-text
subl_install() {
  if check_exist apt-get; then
    sudo apt-get install apt-transport-https wget
    # Install GPG key
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" \
    | sudo tee /etc/apt/sources.list.d/sublime-text.list
    # Update apt sources and install Sublime Text
    sudo apt-get update
    sudo apt-get install sublime-text
  elif check_exist pacman; then
    wget https://download.sublimetext.com/sublimehq-pub.gpg \
    && sudo pacman-key --add sublimehq-pub.gpg \
    && sudo pacman-key --lsign-key 8A8F901A \
    && rm sublimehq-pub.gpg
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" \
    | sudo tee -a /etc/pacman.conf
    sudo pacman -Syu sublime-text
  else
    echo "Not supported distro"
  fi
}

############
# Define var
############

declare -a PYLIB=(
    future capstone crypto gmpy2 numpy requests pysocks pytest nose
  )

declare -a COMMON_APPS=(
    build-essential cmake curl gdb git pkg-config
    p7zip zip unzip unrar file-roller thunar-archive-plugin
    pulseaudio pavucontrol alsa-utils vlc wget ffmpeg
    compton elinks evince vim viewnior
    #dkms elinks zathura-pdf-poppler
    gnome-screenshot gvfs htop iotop
    lshw nasm netcat nmap
    tree zsh
    radare2 gnome-keyring rsync smartmontools sqlite {l,s}trace
    shellcheck
    xfce4-notifyd texstudio
  )

declare -a DEBIAN_APPS=(
    apt-transport-https firmware-linux gtk2-engines-murrine
    {gcc,g++}-multilib python{,3}-pil
    lcdf-typetools libavcodec-extra libgtk{2.0,-3}-dev
    libimage-exiftool-perl lm-sensors
    arc-theme wireshark tshark xinput
    qt4-qtconfig
    #qt5-default
    ssh
    texlive-{lang-other,latex-extra}
    )

declare -a ARCH_APPS=(
    gtk-engine-murrine ffmpeg
    python{,2}-pillow
    gtk{,mm}3 # for C and C++
    perl-image-exiftool lm_sensors
    arc-solid-gtk-theme wireshark-qt xorg-xinput
    #qt{4,5-base}
    openssh
    texlive-{langextra,latexextra}
    )

apps_install() {
  echo "This script will install:"
  echo "${COMMON_APPS[*]}"
  if check_exist pacman; then
    echo "${ARCH_APPS[*]} ..."
  elif check_exist apt-get; then
    echo "${DEBIAN_APPS[*]} ..."
  fi

  if ask_install "Do you want to install these apps ?"; then
    echo "[+] Ignoring installing ..."
    return 0
  fi

  if check_exist pacman; then # Arch Linux
    sudo pacman --needed --noconfirm -Syu "${COMMON_APPS[@]}"
    echo "Installing ${ARCH_APPS[*]} ..."
    sudo pacman --needed --noconfirm -S "${ARCH_APPS[@]}"

    for lib in "${PYLIB[@]}"; do
      echo "    -> installing" python{,2}"-${lib}"
      sudo pacman --needed --noconfirm -S python{,2}"-${lib}"
    done

  elif check_exist apt-get; then
    sudo apt-get update
    sudo apt-get  --yes install "${COMMON_APPS[@]}"
    echo "Installing ${DEBIAN_APPS[*]} ..."
    sudo apt-get  --yes install "${DEBIAN_APPS[@]}"

    for lib in "${PYLIB[@]}"; do
      echo "    -> installing " python{,3}"-${lib}"
      sudo apt-get --yes install python{,3}"-${lib}"
    done
  fi
}

apps_remove() {
  declare -a DEFAUTL_REMOVE_APPS=(bluez gedit nano reportbug vim-tiny xterm)
  echo "[+] Listing apps..."
  echo "${DEFAUTL_REMOVE_APPS[@]}"

  if ! ask_install "Do you want to remove these apps ?"; then
    echo "[+] Installing ..."
    apt-get autoremove --purge "${DEFAUTL_REMOVE_APPS[@]}"
  else
    echo "[+] Ignoring removing ..."
  fi
  unset DEFAUTL_REMOVE_APPS
}

apps_install


# Clean up
unset check_exist subl_install ask_install apps_install apps_remove
unset PYLIB COMMON_APPS DEBIAN_APPS ARCH_APPS
