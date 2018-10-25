#! /usr/bin/env bash

# -- Load shell dotfiles ---------------------------------------------------------

# * "$HOME/.path" can be used to extend `$PATH`.
# * "$HOME/.extra" can be used for other settings you don't want to commit.
[[ -f "${HOME}/.paths" ]] && source "${HOME}/.paths"
[[ -f "${HOME}/.exports" ]] && source "${HOME}/.exports"
[[ -f "${HOME}/.extra" ]] && source "${HOME}/.extra"
[[ -f "${HOME}/.aliases" ]] && source "${HOME}/.aliases"

# -- Cleaning up -----------------------------------------------------------------

unset \
  m_compinit_age \
  m_get_shell_type \
  m_check_exist
