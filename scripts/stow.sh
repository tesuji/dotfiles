#!/bin/sh

solve_stow_conflict() { # solve_stow_conflict path backup
  path="$1"
  backup="$2"
  m_error=""

  stow -nv -t "$HOME" "$path" 2>&1 \
  | sed -n 's/^  \*.*: //p' \
  | while read -r m_error; do
    m_error="${HOME}/${m_error}"
    if [ -f "${m_error}" ] || [ -L "${m_error}" ]; then
      case "$backup" in
      true)
        >&2 printf '[!] Backup %s to %s' "$1" "${BACKUP_PATH}"
        mv "${m_error}" -t "${BACKUP_PATH}"
        ;;
      false)
        rm -f "${m_error}"
        ;;
      *)
        >&2 printf '[!] Error: Unknown option: %s\n' "${backup}"
        exit 11
        ;;
      esac
    else
      >&2 printf '[!] "%s" is a folder. Exitting ...\n' "${m_error}"
      exit 127
    fi
  done

  stow -t "$HOME" "$path"
}
