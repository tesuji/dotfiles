#!/bin/sh
# ~/.profile: Executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# See /usr/share/doc/bash/examples/startup-files for examples.
# The files are located in the bash-doc package.
#
# The default umask is set in /etc/profile; for setting the umask
# For ssh logins, install and configure the libpam-umask package.
#umask 022

# -- Helper functions ---------------------------------------------------------

# Check if program exists
command_exist() {
  # POSIX compatible, not with `hash', `type', etc.
  command -v "$1" > /dev/null
}

path_merge_wrapper() {
  case ":${PATH}:" in
    *":${1}:"* ) return;;
    * )
      if [ -n "$2" ]; then
        PATH="${PATH:+${PATH}:}${1}"
      else
        PATH="${1}${PATH+:${PATH}}"
      fi
      ;;
  esac
}

# Prepend path to begin
path_prepend() {
  path_merge_wrapper "$1"
}

# Append path to end
path_append() {
  path_merge_wrapper "$1" 'append'
}

# -- Set PATH -----------------------------------------------------------------

# Set PATH so it includes sbin program
# NOTE: In zsh, read https://wiki.archlinux.org/index.php/zsh#Configuring_.24PATH
#for p in /sbin /usr/sbin /usr/local/sbin; do
#  path_prepend "$p"
#done

# Set PATH so it includes user's private bin if it exists
# and ~/.local/bin which is defined in FHS.
for p in "${HOME}/bin" "${HOME}/.local/bin"; do
  [ -d "$p" ] && path_append "$p"
done

# -- Exported environment variable --------------------------------------------

# Enable the keyring for applications run through the terminal, such as SSH.
#
# We want to prefer `gpg-agent` when possible (because it has nice UI) and
# fallback to use `ssh-agent`.
#
# For more info, read:
# * https://wiki.archlinux.org/index.php/SSH_keys#ssh-agent
# * https://wiki.archlinux.org/index.php/GnuPG#SSH_agent

# Disabled, see <https://unix.stackexchange.com/a/371910/178265>
# For `gpg-agent` to work correctly.
# GPG_TTY=$(tty)
# export GPG_TTY
# if command_exist gpg-connect-agent; then
#   gpg-connect-agent updatestartuptty /bye > /dev/null
# fi

if command_exist ssh-agent; then
  if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -s > "$XDG_RUNTIME_DIR/ssh-agent.env"
  fi
  if [ -z "$SSH_AUTH_SOCK" ]; then
    . "$XDG_RUNTIME_DIR/ssh-agent.env" > /dev/null
  fi
fi

# Set less options
#PAGER="less"
export LESS='--line-numbers --RAW-CONTROL-CHARS'
LESS_TERMCAP_mb=$(printf '\e[1;36m')    # begin blink
LESS_TERMCAP_md=$(printf '\e[1;31m')    # begin bold
LESS_TERMCAP_me=$(printf '\e[0m')       # reset bold/blink
LESS_TERMCAP_so=$(printf '\e[1;44;33m') # begin reverse video
LESS_TERMCAP_se=$(printf '\e[0m')       # reset reverse video
LESS_TERMCAP_us=$(printf '\e[1;32m')    # begin underline
LESS_TERMCAP_ue=$(printf '\e[0m')       # reset underline
export LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me LESS_TERMCAP_so LESS_TERMCAP_se LESS_TERMCAP_us LESS_TERMCAP_ue
export LESSHISTFILE='-' # prevent less' history file
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Make vim the default editor.
export EDITOR='vim'
export VISUAL="${EDITOR}"

# Prefer US English and use UTF-8.
# Ref https://wiki.archlinux.org/index.php/locale
export LC_CTYPE='en_US.UTF-8'
#LC_TIME="en_GB.UTF-8"
#LC_PAPER="en_GB.UTF-8"
#LC_MEASUREMENT="en_GB.UTF-8"
export LANG='en_US.UTF-8'
# WARNING: Using LC_ALL is strongly discouraged as it overrides everything.
# Please use it only when testing and never set it in a startup file.
#LC_ALL='en_US.UTF-8'

export PYTHONSTARTUP="${HOME}/.pythonrc"
#SYSTEMD_LESS='FRSMK'

# MySQL prompt
#MYSQL_PS1="\R|\m:\s \h.\d> "

# Check whether we are in SSH sessions
# https://unix.stackexchange.com/a/9607/178265
if [ -n "${SSH_CLIENT}" ] || [ -n "${SSH_CONNECTION}" ] || [ -n "${SSH_TTY}" ]; then
  SESSION_TYPE=ssh
else
  case "/$(ps -o comm= -p "${PPID}")" in
    */sshd ) SESSION_TYPE=ssh;;
  esac
fi

export SESSION_TYPE

# NOTE:
#   Some shells have their own builtin version of ps so we use `command`
#   keyword to force the shell use the external ps.
# NOTE:
#   "command" is a shell builtin, which means that it is followed by the
#   external program you want to run
#CURRENT_SHELL="$(command ps -p "$$" --no-headers -o cmd)"
