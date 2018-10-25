#!/usr/bin/env bash
# ~/.bashrc: "Interactive", non-login shells

# Bash is considered an "interactive shell" when its standard input
# and error are connected to a terminal

# Per-user, after /etc/bash.bashrc.

# If using Putty, change xterm to xterm-256color in connection -> data

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source "${HOME}/.bash_preinit.sh"

# Make less more friendly for non-text input files, see lesspipe(1)
#[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

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
if [ -e "$HOME/.ssh/config" ]; then
  m_hosts="$(grep "^Host\b" ${HOME}/.ssh/config | awk '{ print $2 }')"
  complete -o "default" -o "nospace" -W "${m_hosts}" scp sftp ssh
  unset m_hosts
fi

# -- Load shell dotfiles ---------------------------------------------------------

[[ -f "${HOME}/.bash_prompt" ]] && source "${HOME}/.bash_prompt"
source "${HOME}/.bash_postinit.sh"
