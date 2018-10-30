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
    profile_dir=$(grep -E '^(\[Profile|Path|Default)' "$PROFILE_INI" \
                    | grep -B1 '^Default=1' \
                    | awk -v FS='=' '/^Path=/{ print $2 }')
  else
    profile_dir="$( awk -v FS='=' '/^Path=/{ print $2 }' "$PROFILE_INI" )"
  fi

  printf '%s' "$PARENT_FF_DIR/$profile_dir"
}

start_install() {
  if PROFILE_DIR="$( get_firefox_profile )"; then
    (cd "${HERE_DIR}/.." && stow -v -t "$PROFILE_DIR" firefox)
  else
    >&2 cat << EOF
[x] Cannot install firefox tweaks
[x] Firefox directory not found
EOF
  fi
}

start_install
