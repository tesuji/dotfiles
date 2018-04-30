#!/bin/sh
export SSH_ASKPASS=/usr/bin/ksshaskpass
ssh-add "$HOME"/.ssh/id_rsa "$HOME"/.ssh/id_ed25519 </dev/null
