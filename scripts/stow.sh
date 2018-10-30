#!/bin/sh

solve_stow_conflict() { # solve_stow_conflict path backup
  tmp_path="$1"
  is_backup="$2"
  err_line=""

  stow -nv -t "$HOME" "$tmp_path" 2>&1 \
  | sed -n 's/^  \*.*: //p' \
  | while read -r err_line; do
    err_line="${HOME}/${err_line}"
    if [ -f "${err_line}" ] || [ -L "${err_line}" ]; then
      if [ "${is_backup}" -eq 1 ]; then
        >&2 printf '[!] Backup %s to %s' "$1" "${is_backup_PATH}"
        mv "${err_line}" -t "${is_backup_PATH}"
      elif [ "${is_backup}" -eq 0 ]; then
        rm -f "${err_line}"
      else
        >&2 printf '[!] Error: Unknown option: %s\n' "${is_backup}"
        exit 11
      fi
    else
      >&2 printf '[!] "%s" is a folder. Exitting ...\n' "${err_line}"
      exit 127
    fi
  done

  stow -t "$HOME" "$tmp_path"
}

HERE_DIR="$( cd "$(dirname "$0")" && pwd -P )"
. "$HERE_DIR/ifmain.sh"

if ifmain; then
  solve_stow_conflict "$@"
fi

unset HERE_DIR
unset ifmain
