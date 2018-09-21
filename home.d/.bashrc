#!/usr/bin/env bash
## ~/.bashrc: "Interactive", non-login shells

## Bash is considered an "interactive shell" when its standard input
## and error are connected to a terminal

## Per-user, after /etc/bash.bashrc.

## if using PUTTY, change xterm to xterm-256color in connection -> data

## If not running interactively, don't do anything
[[ $- != *i* ]] && return

## make less more friendly for non-text input files, see lesspipe(1)
#[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

## append to the history file, don't overwrite it
shopt -s histappend

## Autocorrect typos in path names when using `cd`
shopt -s cdspell

## auto "cd" when entering just a path
#shopt -s autocd

## If set, the pattern "**" used in a pathname expansion context will
## match all files and zero or more directories and subdirectories.
#shopt -s globstar

## Tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && \
  complete -o "default" -o "nospace" -W \
    "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

## Load the shell dotfiles, and then some:
##   * ~/.path can be used to extend $PATH.
##   * ~/.extra can be used for other settings you don’t want to commit.
[[ -f "${HOME}/.paths" ]] && source "${HOME}/.paths"
[[ -f "${HOME}/.bash_prompt" ]] && source "${HOME}/.bash_prompt"
[[ -f "${HOME}/.exports" ]] && source "${HOME}/.exports"
[[ -f "${HOME}/.extra" ]] && source "${HOME}/.extra"
[[ -f "${HOME}/.aliases" ]] && source "${HOME}/.aliases"

## end of file
