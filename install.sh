#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
BACKUP=false
BACKUP_PATH=".backup"

declare -a CORE_DIR=(
    "compton"
    "config.d"
    "home.d"
    ## You will need Windows fonts if you wanna enable this fontconfig
    #fontconfig
    "subl"
    "xfce4"
    )

############
## Functions
############

solve_stow_conflict() { # solve_stow_conflict path backup
  local path="$1"
  local backup="$2"

  stow -nv -t "$HOME" "$path" 2>&1 | sed -n 's/^  \*.*: //p' | while read error; do
    error="${HOME}/${error}"
    if [[ -d "$error" ]]; then
      echo "\"$error\" is a folder. Exitting"
      exit 127
    fi
    case "$backup" in
      true )
        echo "[!] Backup $1 to ${BACKUP_PATH}" 2>&1
        mv "$error" -t "${BACKUP_PATH}"
        ;;
      false )
        rm -f "$error"
        ;;
      * )
        echo "[!] Error: Unknown option: ${backup}" 2>&1
        exit 11
        ;;
    esac
  done

  stow -t "$HOME" "$path"
}

start() { # start backup
  cd "$SCRIPTPATH"
  for dir in ${CORE_DIR[@]}; do
    solve_stow_conflict "$dir" "$1"
  done
  cd -
}

usage() { echo "Usage: $0 [-b]" 1>&2; exit 1; }

## Ref https://stackoverflow.com/a/34531699/5456794
handle_option() {
  while getopts ":b" opt; do
    case ${opt} in
    b  ) BACKUP=true ;;
    \? )
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
    :  )
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
