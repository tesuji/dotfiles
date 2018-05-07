#!/usr/bin/env bash

solve_stow_conflict() { # solve_stow_conflict path backup
  local path="$1"
  local backup="$2"

  stow -nv -t "$HOME" "$path" 2>&1 | sed -n 's/^  \*.*: //p' | while read error; do
    error="${HOME}/${error}"
    if [[ ( -f "$error" ) || ( -L "$error" ) ]]; then
      case "$backup" in
        (true)
          echo "[!] Backup $1 to ${BACKUP_PATH}" 2>&1
          mv "$error" -t "${BACKUP_PATH}"
          ;;
        (false)
          rm -f "$error"
          ;;
        (*)
          echo "[!] Error: Unknown option: ${backup}" 2>&1
          exit 11
          ;;
      esac
    else
      echo "\"$error\" is a folder. Exitting"
      exit 127
    fi
  done

  stow -t "$HOME" "$path"
}

