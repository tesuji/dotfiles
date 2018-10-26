#!/bin/sh

solve_stow_conflict() { # solve_stow_conflict path backup
  M_PATH="$1"
  BACKUP="$2"
  M_ERROR=""

  stow -nv -t "$HOME" "$M_PATH" 2>&1 \
  | sed -n 's/^  \*.*: //p' \
  | while read -r M_ERROR; do
    M_ERROR="${HOME}/${M_ERROR}"
    if [ -f "${M_ERROR}" ] || [ -L "${M_ERROR}" ]; then
      if [ "${BACKUP}" -eq 1 ]; then
        >&2 printf '[!] Backup %s to %s' "$1" "${BACKUP_PATH}"
        mv "${M_ERROR}" -t "${BACKUP_PATH}"
      elif [ "${BACKUP}" -eq 0 ]; then
        rm -f "${M_ERROR}"
      else
        >&2 printf '[!] Error: Unknown option: %s\n' "${BACKUP}"
        exit 11
      fi
    else
      >&2 printf '[!] "%s" is a folder. Exitting ...\n' "${M_ERROR}"
      exit 127
    fi
  done

  stow -t "$HOME" "$M_PATH"
}

HERE_DIR="$( cd "$(dirname "$0")" && pwd -P )"
. "$HERE_DIR/ifmain.sh"

if ifmain; then
  solve_stow_conflict "$@"
fi

unset HERE_DIR
unset ifmain
