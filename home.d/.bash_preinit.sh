#! /usr/bin/env bash

# -- Functions -----------------------------------------------------------------

# Usage: m_compinit_age -> time
# Return the string represents how long has "$HOME/.zcompdump" been modified
m_compinit_age() {
  local LAST_MODIFIED CURRENT_TIME
  LAST_MODIFIED=$(stat -c '%Y' "${HOME}/.zcompdump")
  CURRENT_TIME=$(date '+%s')
  printf '%s' "$(( CURRENT_TIME - LAST_MODIFIED ))"
}

# Usage: m_get_shell_type -> str
# Return kind of shell: bash or zsh
# NOTE:
#   Some shells have their own builtin version of ps so we use `command`
#   keyword to force the shell use the external ps.
# NOTE:
#   "command" is a shell builtin, which means that it is followed by the
#   external program you want to run
m_get_shell_type() {
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
