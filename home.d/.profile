# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Set PATH so it includes sbin program
# NOTE: In zsh, read https://wiki.archlinux.org/index.php/zsh#Configuring_.24PATH
case ":${PATH}:" in
*":/sbin:"* ) ;;
* ) PATH="/sbin/:/usr/sbin:/usr/local/sbin${PATH+:${PATH}}";;
esac

# Set PATH so it includes user's private bin if it exists
[ -d "${HOME}/bin" ] && PATH="${PATH:+${PATH}:}${HOME}/bin"
# Set PATH so it includes user's private bin if it exists
[ -d "${HOME}/.local/bin" ] && PATH="${PATH:+${PATH}:}${HOME}/.local/bin"

# -- Exported environment variable --------------------------------------------

# Enable the keyring for applications run through the terminal, such as SSH
[ -n "${DESKTOP_SESSION}" ] && [ -x /usr/bin/gnome-keyring-daemon ] \
&& eval "$(/usr/bin/gnome-keyring-daemon --start)" && export SSH_AUTH_SOCK

# Set less options
#PAGER="less"
LESS="--line-numbers --RAW-CONTROL-CHARS"
LESSHISTFILE='-' # prevent less' history file
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Make vim the default editor.
EDITOR='vim'
VISUAL="${EDITOR}"

# Prefer US English and use UTF-8.
# Ref https://wiki.archlinux.org/index.php/locale
LC_CTYPE='en_US.UTF-8'
#LC_TIME="en_GB.UTF-8"
#LC_PAPER="en_GB.UTF-8"
#LC_MEASUREMENT="en_GB.UTF-8"
LANG='en_US.UTF-8'
# WARNING: Using LC_ALL is strongly discouraged as it overrides everything.
# Please use it only when testing and never set it in a startup file.
#LC_ALL='en_US.UTF-8'

PYTHONSTARTUP="${HOME}/.pythonrc"
#SYSTEMD_LESS='FRSMK'

# MySQL prompt
#MYSQL_PS1="\R|\m:\s \h.\d> "

# Check whether we are in SSH sessions
# https://unix.stackexchange.com/a/9607/178265
if [ -n "${SSH_CLIENT}" ] || [ -n "${SSH_CONNECTION}" ] || [ -n "${SSH_TTY}" ]; then
  SESSION_TYPE=ssh
else
  case "/$(ps -o comm= -p "${PPID}")" in
  *"/sshd") SESSION_TYPE=ssh;;
  esac
fi

# NOTE:
#   Some shells have their own builtin version of ps so we use `command`
#   keyword to force the shell use the external ps.
# NOTE:
#   "command" is a shell builtin, which means that it is followed by the
#   external program you want to run
#CURRENT_SHELL="$(command ps -p "$$" --no-headers -o cmd)"

export LESS LESSHISTFILE EDITOR VISUAL LC_CTYPE LANG PYTHONSTARTUP SESSION_TYPE
