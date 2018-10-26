#!/bin/sh
set -e

HERE_DIR="$( cd "$(dirname "$0")" && pwd -P )"

get_firefox_profile() {
  readonly PARENT_FF_DIR="$HOME/.mozilla/firefox"
  readonly PROFILE_INI="$PARENT_FF_DIR/profiles.ini"

  if [ ! -f "$PROFILE_INI" ]; then
    return 1
  fi

  if grep -q '\[Profile[^0]\]' "$PROFILE_INI" ; then
    PROFILE_DIR=$(\
        grep -E '^\[Profile|^Path|^Default' "$PROFILE_INI" \
        | grep -1 '^Default=1' \
        | grep '^Path' | cut -d= -f2 )
  else
    PROFILE_DIR=$( grep 'Path=' "$PROFILE_INI" | cut -d= -f2 )
  fi

  printf '%s' "$PARENT_FF_DIR/$PROFILE_DIR"
}

start_install() {
  if PROFILE_DIR=$( get_firefox_profile ); then
    (cd "${HERE_DIR}/.." && stow -v -t "$PROFILE_DIR" firefox)
  else
    >&2 cat << EOF
[x] Cannot install firefox tweaks
[x] Firefox directory not found
EOF
  fi
}

start_install
