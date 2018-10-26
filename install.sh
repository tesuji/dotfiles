#!/usr/bin/env bash
set -e

SCRIPT_PATH="$( cd "$(dirname "$0")" || exit 1; pwd -P )"
BACKUP=0
BACKUP_PATH=".backup"

declare -a CORE_DIR=(
  #"compton"
  "config.d"
  "home.d"
  # You will need Windows fonts if you wanna enable this fontconfig
  "fontconfig"
  "subl"
  #"xfce4"
)

#-- Functions -------------------------------------------------------------------

source scripts/stow.sh # load solve_stow_conflict()

usage() {
  >&2 printf 'Usage: %s [-b]\n' "$0"
  exit 1
}

# Ref https://stackoverflow.com/a/34531699/5456794
handle_option() {
  while getopts ':b' opt; do
    case "${opt}" in
    b ) BACKUP=true ;;
    \? )
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
    : )
      echo "Option -$OPTARG requires an argument." >&2
      usage
      ;;
    esac
  done
  shift $(( OPTIND -1 ))
}

start() { # start backup
  [ "${BACKUP}" -ne 0 ] && mkdir -p "${BACKUP_PATH}"

  for DIR in "${CORE_DIR[@]}"; do
    solve_stow_conflict "${DIR}" "$1"
  done

}

# -- Starting here ---------------------------------------------------------------

handle_option "$@"

pushd "${SCRIPT_PATH}"
( start "$BACKUP" )
popd
