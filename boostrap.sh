#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# This script is used to installing some useful program
# Only testing for Arch and Debian Linux
# Use at your own risk!
# ------------------------------------------------------------------------------

#-- Functions ------------------------------------------------------------------

# Ask for installation
ask_install() { # ask_install question
  echo
  read -r -p "$1 (y/N) " -n 1
  echo
  if printf '%s' "$REPLY" | grep -q '^[Yy]$'; then
    return 0
  else
    return 1
  fi
}

# Install sublime-text
subl_install() {
  if [ -x '/usr/bin/apt-get' ]; then
    sudo apt-get install apt-transport-https wget
    # Install GPG key
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    printf 'deb https://download.sublimetext.com/ apt/stable/\n' \
    | sudo tee /etc/apt/sources.list.d/sublime-text.list
    # Update apt sources and install Sublime Text
    sudo apt-get update
    sudo apt-get install sublime-text
  elif [ -x '/bin/pacman' ]; then
    wget https://download.sublimetext.com/sublimehq-pub.gpg \
    && sudo pacman-key --add sublimehq-pub.gpg \
    && sudo pacman-key --lsign-key 8A8F901A \
    && rm sublimehq-pub.gpg
    cat << EOF | sudo tee -a /etc/pacman.conf

[sublime-text]
Server = https://download.sublimetext.com/arch/stable/x86_64
EOF
    sudo pacman -Syu sublime-text
  else
    >&2 printf 'Not supported distro\n'
  fi
}

#-- Define variables -----------------------------------------------------------

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
  fonts-mathjax
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
  >&2 printf 'This script will install:\n%s' "${COMMON_APPS[*]}"
  if [ -x '/bin/pacman' ]; then
    >&2 printf '%s ...\n' "${ARCH_APPS[*]}"
  elif [ -x '/usr/bin/apt-get' ]; then
    >&2 printf '%s ...\n' "${DEBIAN_APPS[*]}"
  fi

  if ! ask_install 'Do you want to install these apps ?'; then
    >&2 printf '[+] Ignoring installing ...\n'
    return 0
  fi

  if [ -x '/bin/pacman' ]; then # Arch Linux
    sudo pacman --needed --noconfirm -Syu "${COMMON_APPS[@]}"
    >&2 printf 'Installing %s ...\n' "${ARCH_APPS[*]}"
    sudo pacman --needed --noconfirm -S "${ARCH_APPS[@]}"

    for lib in "${PYLIB[@]}"; do
      >&2 printf '    -> installing %s\n' python{,2}"-${lib}"
      sudo pacman --needed --noconfirm -S python{,2}"-${lib}"
    done

  elif [ -x '/usr/bin/apt-get' ]; then
    sudo apt-get update
    sudo apt-get  --yes install "${COMMON_APPS[@]}"
    >&2 printf 'Installing %s ...\n' "${DEBIAN_APPS[*]}"
    sudo apt-get  --yes install "${DEBIAN_APPS[@]}"

    for lib in "${PYLIB[@]}"; do
      >&2 printf '    -> installing %s\n' python{,3}"-${lib}"
      sudo apt-get --yes install python{,3}"-${lib}"
    done
  fi
}

apps_remove() {
  declare -a DEFAUTL_REMOVE_APPS=(
    bluez
    gedit
    nano
    reportbug
    vim-tiny
    xterm
  )
  >&2 printf '[+] Listing apps...\n%s' "${DEFAUTL_REMOVE_APPS[@]}"

  if ask_install 'Do you want to remove these apps ?'; then
    >&2 printf '[+] Installing ...\n'
    apt-get purge "${DEFAUTL_REMOVE_APPS[@]}"
  else
    >&2 printf '[+] Ignoring removing ...\n'
  fi
  unset DEFAUTL_REMOVE_APPS
}

# -- Starting here -------------------------------------------------------------

apps_install

# -- Clean up ------------------------------------------------------------------

unset subl_install ask_install apps_install apps_remove
unset PYLIB COMMON_APPS DEBIAN_APPS ARCH_APPS
