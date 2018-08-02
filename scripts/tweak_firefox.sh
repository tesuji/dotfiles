#!/usr/bin/env bash
#
readonly SCRIPTPATH="$( cd "$(dirname "$0")" || exit 1; pwd -P )"

get_firefox_profile()
{
  readonly PARENT_FF_DIR="$HOME/.mozilla/firefox"
  readonly PROFILE_INI="$PARENT_FF_DIR/profiles.ini"

  if [[ ! -f "$PROFILE_INI" ]]; then
    return 1
  fi

  if grep --quiet '\[Profile[^0]\]' "$PROFILE_INI" ; then
    PROFILE_DIR=$(\
        grep -E '^\[Profile|^Path|^Default' "$PROFILE_INI" \
        | grep -1 '^Default=1' \
        | grep '^Path' | cut -d= -f2 )
  else
    PROFILE_DIR=$( grep 'Path=' "$PROFILE_INI" | cut -d= -f2 )
  fi

  echo "$PARENT_FF_DIR/$PROFILE_DIR"
}

start_install()
{
  if PROFILE_DIR=$( get_firefox_profile ); then
    (cd "$SCRIPTPATH/.." && stow -v -t "$PROFILE_DIR" firefox)
  else
    echo "[x] Cannot install firefox tweaks"
    echo "[x] Firefox directory not found"
  fi
}

start_install
