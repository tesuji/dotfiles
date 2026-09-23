#!/bin/sh

ifmain() {
  # Ref https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
  sourced=0
  if [ -n "${ZSH_EVAL_CONTEXT}" ]; then
    printf '%s' "${ZSH_EVAL_CONTEXT}" | grep -q '^toplevel:file$' && sourced=1
  elif [ -n "${KSH_VERSION}" ]; then
    # Special variable ${.sh.file} is somewhat analogous to $BASH_SOURCE
    # in Korn shell
    lvalue="$(cd "$(dirname -- "$0")" && pwd -P)/$(basename -- "$0")"
    # shellcheck disable=SC2154
    rvalue="$(cd "$(dirname -- "${.sh.file}")" && pwd -P)/$(basename -- "${.sh.file}")"
    [ "$lvalue" != "$rvalue" ] && sourced=1
    unset lvalue rvalue
  elif [ -n "${BASH_VERSION}" ]; then
    # shellcheck disable=SC2128
    [ "$0" != "${BASH_SOURCE}" ] && sourced=1
  else # All other shells: examine $0 for known shell binary filenames
    # Detects `sh` and `dash`; add additional shell filenames as needed.
    case ${0##*/} in sh|dash) sourced=1;; esac
  fi
  return "$sourced"
}
