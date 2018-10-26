#!/bin/sh

ifmain() {
  # Taken from
  #   https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
  SOURCED=0
  if [ -n "${ZSH_EVAL_CONTEXT}" ]; then
    printf '%s' "${ZSH_EVAL_CONTEXT}" | grep -q '^toplevel:file$' && SOURCED=1
  elif [ -n "${KSH_VERSION}" ]; then
    # Special variable ${.sh.file} is somewhat analogous to $BASH_SOURCE
    # in Korn shell
    LVALUE="$(cd "$(dirname -- "$0")" && pwd -P)/$(basename -- "$0")"
    # shellcheck disable=SC2154
    RVALUE="$(cd "$(dirname -- "${.sh.file}")" && pwd -P)/$(basename -- "${.sh.file}")"
    [ "$LVALUE" != "$RVALUE" ] && SOURCED=1
    unset LVALUE RVALUE
  elif [ -n "${BASH_VERSION}" ]; then
    # shellcheck disable=SC2128
    [ "$0" != "${BASH_SOURCE}" ] && SOURCED=1
  else # All other shells: examine $0 for known shell binary filenames
    # Detects `sh` and `dash`; add additional shell filenames as needed.
    case ${0##*/} in sh|dash) SOURCED=1;; esac
  fi
  return "$SOURCED"
}
