#! /usr/bin/env bash

# -- Functions -------------------------------------------------------------------

# m_compinit_age -> time
# Return the string represents how long has "$HOME/.zcompdump" been modified
m_compinit_age() {
  local last_modified current
  last_modified=$(stat -c '%Y' "${HOME}/.zcompdump")
  current=$(date '+%s')
  echo $(( current - last_modified ))
}

# m_get_shell_type -> str
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

# m_check_exist -> bool
# Check if program exists
m_check_exist() {
  # POSIX compatible, not with `hash', `type', etc.
  command -v "$1" > /dev/null
}
