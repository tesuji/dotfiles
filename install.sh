#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" || exit 1; pwd -P )"
BACKUP=false
BACKUP_PATH=".backup"

declare -a CORE_DIR=(
    #"compton"
    "config.d"
    "home.d"
    ## You will need Windows fonts if you wanna enable this fontconfig
    "fontconfig"
    "subl"
    #"xfce4"
    )

############
## Functions
############

source scripts/stow.sh # load solve_stow_conflict()

start() { # start backup
  cd "$SCRIPTPATH" || { echo "Cannot change directory"; exit 1; }

  [[ ${BACKUP} != false ]] && mkdir ${BACKUP_PATH}

  for dir in "${CORE_DIR[@]}"; do
    solve_stow_conflict "$dir" "$1"
  done
  cd - || { echo "Cannot change directory"; exit 1; }
}

usage() { echo "Usage: $0 [-b]" 1>&2; exit 1; }

## Ref https://stackoverflow.com/a/34531699/5456794
handle_option() {
  while getopts ":b" opt; do
    case ${opt} in
      (b) BACKUP=true ;;
      (\?)
        echo "Invalid option: -$OPTARG" >&2
        usage
        ;;
      (:)
        echo "Option -$OPTARG requires an argument." >&2
        usage
        ;;
    esac
  done
  shift $((OPTIND -1))
}

################
## Starting here
################

handle_option "$@"
start "$BACKUP"
