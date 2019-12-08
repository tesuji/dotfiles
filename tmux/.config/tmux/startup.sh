#!/bin/sh
# ~/.tmuxrc.sh: Executed by ~/.tmux.conf to support ancient versions of tmux
# See https://repology.org/metapackage/tmux/badges

set -eu

# If tmux is not run, exit immediately
[ -z "$TMUX" ] && return

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME"/.config}
TMUX_CONFIG_DIR="${XDG_CONFIG_HOME}/tmux"

# -- Function -----------------------------------------------------------------

# Ref https://stackoverflow.com/a/4024263/5456794
verlte() {
  [ "$1" = "$(printf '%s\n%s' "$1" "$2" | sort -V | head -n1)" ]
}

verlt() {
  if [ "$1" = "$2" ]; then
    return 1
  else
    verlte "$1" "$2"
  fi
}

# -- Main ---------------------------------------------------------------------

TMUX_OS="$(uname)"
TMUX_VERSION="$(tmux -V | cut -d' ' -f2)"

case "${TMUX_OS}" in
  Darwin ) tmux source-file "${TMUX_CONFIG_DIR}/macos.conf";;
  #FreeBSD ) tmux source-file "${TMUX_CONFIG_DIR}/freebsd.conf";;
  #*) tmux display -p "Unknown OS";;
esac

if verlte "$TMUX_VERSION" 2.0; then
  tmux source-file "${TMUX_CONFIG_DIR}/18.conf"
elif verlte "$TMUX_VERSION" 2.3; then
  tmux source-file "${TMUX_CONFIG_DIR}/23.conf"
else
  tmux source-file "${TMUX_CONFIG_DIR}/24_plus.conf"
fi
