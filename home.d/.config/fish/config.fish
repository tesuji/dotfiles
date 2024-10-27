#!/usr/bin/env fish

if not status is-interactive
  exit
end

fish_add_path "$HOME/.cargo/bin" "$HOME/.local/bin"

# Disable greetings text on every runs
set -g fish_greeting

# from <https://github.com/fish-shell/fish-shell/issues/8635>.
set fish_cursor_default     block
set fish_cursor_insert      line
set fish_cursor_replace_one underscore
set fish_cursor_visual      block

fish_config prompt choose informative
# Vi-style bindings that inherit emacs-style bindings in all modes
function fish_hybrid_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
    bind --user \ca beginning-of-line
    bind --user \ce end-of-line
    bind --preset -M insert \e\[3\;5\~ kill-word
end
set -g fish_key_bindings fish_hybrid_key_bindings

# For `gpg-agent` to work correctly.
set -gx GPG_TTY (tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

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
if [ "$REMOTE_HOST" = true ]
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

# Make path for each argument and cd into the last path
function mkcd
  /bin/mkdir -p "$argv" && cd "$argv[-1]" && pwd
end

### Aliases

if ls --color > /dev/null 2>&1 # GNU ls support colors
  set OS gnu
else if ls --G > /dev/null 2>&1 # BSD ls
  set OS bsd
else
  # this maybe OpenBSD
  set OS unknown
end

[ -f ~/.aliases ] && source ~/.aliases

alias cdroot='cd (git root)'

if [ $OS = gnu ] || [ $OS = bsd ]
  alias ln='ln -iv'
  alias mkdir='mkdir -pv'
  alias mv='mv -iv'
  alias nc='nc -v'
else if [ $OS = unknown ]
  alias ln='ln -i'
  alias mkdir='mkdir -p'
  alias mv='mv -i'
end
