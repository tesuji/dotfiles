#!/usr/bin/env fish
# Commands to run in interactive sessions can go here
if status is-interactive
    fish_config prompt choose informative
    # Vi-style bindings that inherit emacs-style bindings in all modes
    function fish_hybrid_key_bindings
        fish_default_key_bindings -M insert
        fish_vi_key_bindings --no-erase insert
    end
    set -g fish_key_bindings fish_hybrid_key_bindings

    # For `gpg-agent` to work correctly.
    set -gx GPG_TTY (tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null
end

fish_add_path "$HOME/.cargo/bin" "$HOME/.local/bin"

# -- Exported environment variable --------------------------------------------
# NOTE: Most variables should be in ~/.config/environement.d

# Using $DISPLAY to detect remote host is not accurate, using $SSH_* instead.
if [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
  set -gx REMOTE_HOST true
else
  set -gx REMOTE_HOST false
end

set -gx PYTHONSTARTUP $HOME/.pythonrc
set -gx CARGO_TARGET_DIR $HOME/.cargo/target

# Ref: https://wiki.gentoo.org/wiki/GnuPG#Changing_pinentry_for_SSH_logins
if [ -n "$SSH_CONNECTION" ] || [ "$REMOTE_HOST" = true ]
  set -gx PINENTRY_USER_DATA "USE_CURSES=1"
else
  set -e PINENTRY_USER_DATA
end

set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'

if [ -z "$XDG_RUNTIME_DIR" ]
  if [ -d /run/user/ ]
    set -gx XDG_RUNTIME_DIR /run/user/(id -u)
  else
    # For OpenBSD
    set -gx XDG_RUNTIME_DIR /tmp/runtime-(id -u)
    if [ ! -d "$XDG_RUNTIME_DIR" ]
      mkdir -m 0700 "$XDG_RUNTIME_DIR"
    end
  end
end

set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh"

### Functions

function lssh
  ps -ef | command grep '[s]sh.*pts'
end

# Make path for each argument and cd into the last path
function mkcd
  /bin/mkdir -p "$argv" && cd "$argv[-1]" && pwd
end

### Aliases

[ -f ~/.aliases ] && source ~/.aliases

alias cdroot='cd (git root)'
# Only diffutils v3.4+ includes the --color option
# CentOS 7 has diffutils 3.3
if diff --color 2>&1 | grep -q 'missing operand'
  alias diff="diff --unified --color"
end
# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1 # GNU ls support colors
  alias ls="ls -h --color --group-directories-first"
else if ls --G > /dev/null 2>&1 # BSD ls
  alias ls="ls -h -G"
else
  # this maybe OpenBSD
  alias ls="ls -h"
end

if mkdir -v > /dev/null 2>&1
  alias ln='ln -iv'
  alias mkdir='mkdir -pv'
  alias mv='mv -iv'
  alias nc='nc -v'
else
  # OpenBSD doesn't support -v flag
  alias ln='ln -i'
  alias mkdir='mkdir -p'
  alias mv='mv -i'
end
