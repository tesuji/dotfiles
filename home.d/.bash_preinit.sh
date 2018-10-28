#! /usr/bin/env bash

# -- Functions ----------------------------------------------------------------

# Usage: m_check_exist -> bool
# Check if program exists
m_check_exist() {
  # POSIX compatible, not with `hash', `type', etc.
  command -v "$1" > /dev/null
}

# -- Exported variables -------------------------------------------------------

# Check whether we are in SSH sessions
# https://unix.stackexchange.com/a/9607/178265
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=ssh
else
  case "$(ps -o comm= -p "$PPID")" in
    sshd|*/sshd) SESSION_TYPE=ssh;;
  esac
fi

# NOTE:
#   Some shells have their own builtin version of ps so we use `command`
#   keyword to force the shell use the external ps.
# NOTE:
#   "command" is a shell builtin, which means that it is followed by the
#   external program you want to run
CURRENT_SHELL=$(command ps -p "$$" --no-headers -o cmd)

export SESSION_TYPE CURRENT_SHELL
