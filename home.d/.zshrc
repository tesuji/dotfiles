#!/usr/bin/env zsh
# ~/.zshrc: per-user .zshrc file for zsh(1).
#
# This file is sourced only for interactive shells. It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#
# Global Order: zshenv, zprofile, zshrc, zlogin

# Ref http://matt.blissett.me.uk/linux/zsh/zshrc

# If not running interactively, don't do anything
case "$-" in
  *i* )
    [[ ! -o login ]] && [[ -f "${HOME}/.zprofile" ]] && . "${HOME}/.zprofile"
    ;;
  *) return;;
esac

# -- Key bindings -------------------------------------------------------------

# Type Ctrl-V and key combination to get key code
# Type `bindkey' to show all keybindings

# Select editing-style (emacs or vi)
# Read more:
#  - https://jlk.fjfi.cvut.cz/arch/manpages/man/zshzle.1
#  - http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins
bindkey -v

#bindkey '^[2~'          overwrite-mode          # Insert
bindkey '^[3~'          delete-char             # Del

bindkey '^[H'           beginning-of-line       # Home
bindkey '^[F'           end-of-line             # End
bindkey '^A'            beginning-of-line
bindkey '^E'            end-of-line

bindkey '^[D'           backward-char           # Left
bindkey '^[C'           forward-char            # Right

bindkey '^[1;5C'        forward-word            # Ctrl-Left
bindkey '^[1;5D'        backward-word           # Ctrl-Right

# Emacs compatible keymaps in vi-mode
bindkey '^K'            kill-line               # Ctrl-K
bindkey '^U'            backward-kill-line      # Ctrl-U

# Use bash's style for word
autoload -U select-word-style && select-word-style bash

bindkey '^[5~'          history-search-backward # PgUp
bindkey '^[6~'          history-search-forward  # PgDn

# Better searching in vi command mode
bindkey '^R'            history-incremental-search-backward
bindkey -M vicmd '?'    history-incremental-search-backward
bindkey -M vicmd '/'    history-incremental-search-forward

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[A'           up-line-or-beginning-search     # Up
bindkey '^[B'           down-line-or-beginning-search   # Down
bindkey -M vicmd "k"    up-line-or-beginning-search
bindkey -M vicmd "j"    down-line-or-beginning-search

# Putty xterm broken hacks
# Read about putty keymaps: <https://www.emacswiki.org/emacs/PuTTY#toc9>
bindkey '^[1~'          beginning-of-line               # Home
bindkey '^[4~'          end-of-line                     # End
bindkey '^OD'           backward-char                   # Left
bindkey '^OC'           forward-char                    # Right
bindkey '^OA'           up-line-or-beginning-search     # Up
bindkey '^OB'           down-line-or-beginning-search   # Down

# -- History ------------------------------------------------------------------

# These two options disable history sharing with tmux
unsetopt INC_APPEND_HISTORY # Do not write immediately, only when the shell exits
unsetopt SHARE_HISTORY

setopt HIST_IGNORE_ALL_DUPS # Delete old recorded entry if new entry is a duplicate
setopt HIST_IGNORE_SPACE    # Don't record an entry starting with a space
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks before recording entry
setopt HIST_VERIFY          # Don't execute immediately upon history expansion

unsetopt FLOW_CONTROL       # Flow control via ^S/^Q

HISTSIZE=1000                 # 1000 lines of history within the shell
SAVEHIST=1000                 # 1000 lines of history in $HISTFILE
HISTFILE="${HOME}/.zsh_history" # Where to save shell history
# Ignore saving in $HISTFILE, but still in the shell
HISTORY_IGNORE='([bf]g|cd ..|l|l[alsh]|less *|vim *)'

# Watch other user login/out
watch=all   # watch all logins, default "notme"
LOGCHECK=10 # check logins after 10 seconds

# Say how long a command took, if it took more than 10 seconds
REPORTTIME=10

# Make vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
KEYTIMEOUT=1

# -- Completion ---------------------------------------------------------------

# You may have to force rebuild zcompdump:
#    % exec zsh; rm -f ~/.zcompdump; compinit
#
# Print fpath with:
#    % print -rl -- $fpath
fpath+="$HOME/.zfunc"

autoload -Uz compinit # Use modern completion system

# HACK: To make it fast, don't know why.
# Maybe because default ~/.zcompdump file is mean to something else.
ZSH_COMPDUMP="${HOME}/.zcompdump_fast"
compinit -d "${ZSH_COMPDUMP}"

# Should be enable in /etc/zsh/newuser.zshrc.recommended
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Make the alias a distinct command for completion purposes
setopt COMPLETE_ALIASES

# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
setopt RM_STAR_WAIT

# Background processes aren't killed on exit of shell
#setopt AUTO_CONTINUE

# Don't write over existing files with >, use >! instead
#setopt NOCLOBBER

# Don't nice background processes
setopt NO_BG_NICE

# -- Load shell dotfiles ------------------------------------------------------

[ -f "${HOME}/.zsh_prompt" ] && . "${HOME}/.zsh_prompt"
# * "$HOME/.extra" can be used for other settings you don't want to commit.
[ -f "${HOME}/.extra" ] && . "${HOME}/.extra"
[ -f "${HOME}/.aliases" ] && . "${HOME}/.aliases"

# https://wiki.archlinux.org/index.php/zsh#Help_command
autoload -Uz run-help
unalias run-help 2>/dev/null
alias help='run-help'
