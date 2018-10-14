#!/bin/sh
# https://github.com/lzutao/dotfiles/
#
# Try to support ancient version of tmux
# See https://repology.org/metapackage/tmux/badges

# If tmux is not run, exit immediately
[ -z "$TMUX" ] && return

TMUX_OS="$(uname)"
TMUX_VERSION="$(tmux -V | cut -d' ' -f2)"
TMUX_VERSION_MAJOR="$(echo "$TMUX_VERSION" | cut -d'.' -f1)"
TMUX_VERSION_MINOR="$(echo "$TMUX_VERSION" | cut -d'.' -f2)"

case "$TMUX_OS" in
  Darwin ) tmux source-file "${HOME}/.tmux-macos.conf" ;;
  #FreeBSD ) tmux source-file "${HOME}/.tmux-freebsd.conf" ;;
  #*) tmux display -p "Unknown OS" ;;
esac

if [ "$TMUX_VERSION_MAJOR" -le 2 ] && [ "$TMUX_VERSION_MINOR" -le 3 ]; then
  tmux source-file "${HOME}/.tmux-23.conf"
else
  tmux source-file "${HOME}/.tmux-24_plus.conf"
fi
