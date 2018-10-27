#! /usr/bin/env bash

# -- Functions -----------------------------------------------------------------

# Usage: m_current_shell -> str
# Return kind of shell: bash or zsh
# NOTE:
#   Some shells have their own builtin version of ps so we use `command`
#   keyword to force the shell use the external ps.
# NOTE:
#   "command" is a shell builtin, which means that it is followed by the
#   external program you want to run
m_current_shell() {
  command ps -p "$$" --no-headers -o cmd
}

# Usage: m_check_exist -> bool
# Check if program exists
m_check_exist() {
  # POSIX compatible, not with `hash', `type', etc.
  command -v "$1" > /dev/null
}

# Usage: m_check_ssh -> bool
# Check whether we are in SSH sessions
m_check_ssh() {
  [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
}
