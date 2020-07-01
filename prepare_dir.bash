#!/usr/bin/env bash

# This script create empty necessary directories to avoid
# `stow` make symlinks to our sub-directories. So that programs
# will not put their stuff in this repository.

set -eu -o pipefail

EMPTY_DIRS_IN_HOME=(
    .config/autostart
    .config/autostart-scripts

    .config/fontconfig

    .config/git
    .config/hg

    .config/tmux

    .config/Code/User

    .config/xfce4/terminal
    .config/xfce4/xfconf/xfce-perchannel-xml

    .config/sublime-text-3/Packages/User

    .config/vim/autoload
    .config/nvim/
    .local/share/nvim/site/autoload

    .config/pip

    .elinks
    .gnupg

    .cargo/bin

    .local/share/bash-completion/completion
    .zfunc
)

for dir in "${EMPTY_DIRS_IN_HOME[@]}"; do
    mkdir -p "${HOME}/${dir}"
done
