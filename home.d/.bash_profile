#!/usr/bin/env bash
## ~/.bash_profile: executed by bash(1) when "login shell" exits.

## If Bash is spawned by login in a TTY, by an SSH daemon,
## or similar means, it is considered a "login shell"

## Per-user, after /etc/profile. If this file does not exist,
## ~/.bash_login and ~/.profile are checked in that order.
## The skeleton file /etc/skel/.bash_profile also sources ~/.bashrc

[[ -n "$BASH_VERSION" ]] && [[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

export PATH="$HOME/.cargo/bin:$PATH"
