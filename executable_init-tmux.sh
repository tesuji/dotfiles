#!/bin/sh

[[ -z $UID ]] && UID=$(id -u)
GID=$(id -g)
argv=/usr/bin/tmux
source ~/.nix-binds.sh
