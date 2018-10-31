#! /usr/bin/env zsh
# ~/.zprofile: -user .zprofile file for zsh(1).
#
# This file is sourced only for login shells (i.e. shells
# invoked with "-" as the first character of argv[0], and
# shells invoked with the -l flag.)
#
# Global Order: zshenv, zprofile, zshrc, zlogin

# If you don't want compinit called in system-wide in /etc/zsh/zshrc,
# set skip_global_compinit=1
skip_global_compinit=1

[ -f "$HOME/.profile" ] && emulate sh -c '. "$HOME/.profile"'
