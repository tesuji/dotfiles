#!/usr/bin/env zsh
## Ref http://matt.blissett.me.uk/linux/zsh/zshrc

m_compinit_age() {
  local last_modified=$(stat -c "%Y" "${HOME}/.zcompdump")
  local current=$(date +%s)
  echo $(( current - last_modified ))
}

## Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

## FAQ 3.10: Why does zsh not work in an Emacs shell mode any more?
## http://zsh.sourceforge.net/FAQ/zshfaq03.html#l26
#[[ $EMACS = t ]] && unsetopt zle

###############
## Key bindings
###############
## Type Ctrl-V and key combination to get key code
## Type `bindkey' to show all keybindings
bindkey -e        # Emacs keybindings
#bindkey '\e[2~'   overwrite-mode          # Insert
bindkey '\e[3~'   delete-char             # Del
bindkey '\e[1~'   beginning-of-line       # Home
bindkey '\e[4~'   end-of-line             # End
bindkey "\e[H"    beginning-of-line       # Home
bindkey "\e[F"    end-of-line             # End
bindkey "\e0H"    beginning-of-line       # Home
bindkey "\e0F"    end-of-line             # End
bindkey '\e[5~'   history-search-backward # PgUp
bindkey '\e[6~'   history-search-forward  # PgDn
bindkey '\e[A'    up-line-or-history      # Up
bindkey '\e[B'    down-line-or-history    # Down
bindkey '\e[C'    forward-char            # Left
bindkey '\e[D'    backward-char           # Right
bindkey '\eOA'    up-line-or-history      # Up
bindkey '\eOB'    down-line-or-history    # Down
bindkey '\eOC'    forward-char            # Left
bindkey '\eOD'    backward-char           # Right
bindkey '\e[1;5C' forward-word            # Ctrl-Left
bindkey '\e[1;5D' backward-word           # Ctrl-Right
bindkey '^U'      backward-kill-line      # Ctrl-U

## Use bash's style for word
autoload -U select-word-style && select-word-style bash

##########
## History
##########

setopt INC_APPEND_HISTORY   # Write immediately, not when the shell exits
setopt HIST_IGNORE_ALL_DUPS # Delete old recorded entry if new entry is a duplicate
setopt HIST_IGNORE_SPACE    # Don't record an entry starting with a space
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks before recording entry
setopt HIST_VERIFY          # Don't execute immediately upon history expansion

#############
## Completion
#############

## You may have to force rebuild zcompdump:
##     rm -f "$HOME/.zcompdump"; compinit or try rehash command
## Print fpath with (print -rl -- $fpath)
fpath=("$HOME/.zshfuncs" $fpath)

autoload -Uz compinit # Use modern completion system

## If "$HOME/.zcompdump" is modified less than 24h
if [[ m_compinit_age -le 86400 ]]; then
  compinit -C
else
  compinit
fi

## Should be enable in /etc/zsh/newuser.zshrc.recommended
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

## Make the alias a distinct command for completion purposes
setopt COMPLETE_ALIASES

## Prompts for confirmation after 'rm *' etc
## Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
setopt RM_STAR_WAIT

## Background processes aren't killed on exit of shell
#setopt AUTO_CONTINUE

## Don’t write over existing files with >, use >! instead
#setopt NOCLOBBER

## Don’t nice background processes
setopt NO_BG_NICE

#################
## History search
#################
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "$key[Up]"   ]] && bindkey -- "$key[Up]"   up-line-or-beginning-search
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search

######################
## Load shell dotfiles
######################
## * "$HOME/.path" can be used to extend `$PATH`.
## * "$HOME/.extra" can be used for other settings you don't want to commit.
[[ -f "${HOME}/.paths" ]] && source "${HOME}/.paths"
[[ -f "${HOME}/.zsh_prompt" ]] && source "${HOME}/.zsh_prompt"
[[ -f "${HOME}/.exports" ]] && source "${HOME}/.exports"
[[ -f "${HOME}/.aliases" ]] && source "${HOME}/.aliases"
[[ -f "${HOME}/.extra" ]] && source "${HOME}/.extra"

unset m_compinit_age
