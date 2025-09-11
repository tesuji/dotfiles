#!/usr/bin/env fish

if not status is-interactive
  exit
end

# buggy termux fish #11056
# or update to fiah 4.0.2
#set -Ua fish_features no-keyboard-protocols

fish_add_path "$HOME/.cargo/bin" "$HOME/.local/bin"

#if ! test -d /nix;
#  set -l UID (id -u)
#  set -l UID (id -g)
#  set -l BIN "$HOME/.local/bin/fish"
#  source ~/.nix-binds.sh
#end

# Disable greetings text on every runs
set -g fish_greeting

# from <https://github.com/fish-shell/fish-shell/issues/8635>.
set fish_cursor_default     block
set fish_cursor_insert      line
set fish_cursor_replace_one underscore
set fish_cursor_visual      block

fish_config prompt choose terlar

# Vi-style bindings that inherit emacs-style bindings in all modes
function fish_hybrid_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
    bind --user \ca beginning-of-line
    bind --user \ce end-of-line
    bind --preset -M insert \e\[3\;5\~ kill-word
end
set -g fish_key_bindings fish_hybrid_key_bindings
#set -Ua fish_features no-keyboard-protocols

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

#eval (ssh-agent -c)
source $HOME/.config/fish/source-ssh-agent.fish

### Functions

# Make path for each argument and cd into the last path
function mkcd
  /bin/mkdir -p "$argv" && cd "$argv[-1]" && pwd
end

# print duration of last command
function print_time --on-event fish_postexec
    set -l dur $CMD_DURATION
    if [ $dur -gt 5000 ];
         printf "[^] last command took "(math $dur / 1000)" s\n"
    end
end

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+(/?)$' --function multicd
abbr --add clang-format clang-format --style=Google
abbr --add g git
abbr --add vi nvim
abbr --add wget wget --content-disposition
abbr --add rsqlite3 rlwrap sqlite3
abbr --add firefox env DISPLAY=:1 firefox
abbr --add rp-linux "rp-linux -f | rg -v hlt"

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

#set nix_src $HOME/.nix-profile/etc/profile.d/nix.fish
#if test -z $NIX_CC
#    [ -e $nix_src ] && source $nix_src; # added by Nix installer
#end
