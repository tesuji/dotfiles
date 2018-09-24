#!/bin/sh

solve_stow_conflict() { # solve_stow_conflict path backup
  path="$1"
  backup="$2"
  m_error=""

  stow -nv -t "$HOME" "$path" 2>&1 \
  | sed -n 's/^  \*.*: //p' \
  | while read -r m_error; do
    m_error="${HOME}/${m_error}"
    if [ -f "$m_error" ] || [ -L "$m_error" ]; then
      case "$backup" in
        (true)
          echo "[!] Backup $1 to ${BACKUP_PATH}" 2>&1
          mv "$m_error" -t "${BACKUP_PATH}"
          ;;
        (false)
          rm -f "$m_error"
          ;;
        (*)
          echo "[!] Error: Unknown option: ${backup}" 2>&1
          exit 11
          ;;
      esac
    else
      echo "\"$m_error\" is a folder. Exitting"
      exit 127
    fi
  done

  stow -t "$HOME" "$path"
}
