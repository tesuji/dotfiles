#!/usr/bin/env bash
# ~/.bashrc: executed by bash(1) for interactive non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
#
# Bash is considered an "interactive shell" when its standard input
# and error are connected to a terminal
#
# Loaded per-user, after /etc/bash.bashrc.
#
# If using Putty, change xterm to xterm-256color in Connection->Data.

# If not running interactively, don't do anything
case "$-" in
  *i* )
    if ! shopt -q login_shell; then
      [ -f "$HOME/.profile" ] && . "$HOME/.profile"
    fi
    ;;
  *) return;;
esac

# See HISTSIZE and HISTFILESIZE in bash for setting history length
HISTSIZE=1000
HISTFILESIZE=2000
# Do NOT put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth:erasedups

# For `gpg-agent` to work correctly.
GPG_TTY=$(tty)
export GPG_TTY
gpg-connect-agent updatestartuptty /bye >/dev/null

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob
# append to the history file, don't overwrite it
shopt -s histappend
# Autocorrect typos in path names when using `cd`
shopt -s cdspell
# auto "cd" when entering just a path
#shopt -s autocd
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# Tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
lz_ssh_comletion() {
  local SSH_FILES=()
  for f in "${HOME}/.ssh/config" "${HOME}/.ssh/config.local"; do
    [ -e "${f}" ] && SSH_FILES+=( "${f}" )
  done
  if [ "${#SSH_FILES[@]}" -ne 0 ]; then
    complete \
      -o "default" \
      -o "nospace" \
      -W "$(awk '/^Host\s+/{ print $2 }' "${SSH_FILES[@]}")" \
      scp sftp ssh
  fi
}
lz_ssh_comletion
unset lz_ssh_comletion

# -- Load shell dotfiles ------------------------------------------------------

[ -f "${HOME}/.bash_prompt" ] && . "${HOME}/.bash_prompt"
# * "$HOME/.extra" can be used for other settings you don't want to commit.
[ -f "${HOME}/.extra" ] && . "${HOME}/.extra"
[ -f "${HOME}/.aliases" ] && . "${HOME}/.aliases"

alias chi='history -c'
