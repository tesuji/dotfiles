#!/usr/bin/env bash
# ~/.bash_aliases

# -- Functions ----------------------------------------------------------------

# Create useful .gitignore files for your project https://www.gitignore.io
# Or use https://github.com/github/gitignore
ignore() {
  curl -sSL 'https://www.gitignore.io/api/'"$*"
}

# Usage: extract <file>
# Description: extracts archived files / mounts disk images
# Note: .dmg/hdiutil is macOS-specific.
#
# Credit: http://nparikh.org/notes/zshrc.txt
extract() {
  if [ -f "$1" ]; then
    local lower_name
    lower_name="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
    case "${lower_name}" in
      *.tar | *.x )        tar -xvf        "$1";;
      *.tar.bz2 | *.tbz2 ) tar -xjvf       "$1";;
      *.tar.xz )           tar -xJvf       "$1";;
      *.tar.gz | *.tgz )   tar -xzvf       "$1";;
      *.tar.lzma )         tar --lzma -xvf "$1";;
      *.tar.zst )          tar --zstd -xvf "$1";;
      *.bz2 )              bunzip2         "$1";;
      *.xz )               unxz            "$1";;
      *.gz )               gunzip -k       "$1";;
      *.zip )              unzip           "$1";;
      *.rar )              unrar x         "$1";;
      *.7z )               7z e            "$1";;
      *.z )                uncompress      "$1";;
      *.deb )              dpkg --extract  "$@";;
      * )
        >&2 printf '"%s" cannot be extracted via extract()\n' "$1"
        return 1
        ;;
    esac
  else
    >&2 printf '"%s" is not a valid file\n' "$1"
    return 2
  fi
}

tarball() {
  if [ -z "$1" ]; then
    >&2 printf '"%s" is not a valid file\n' "$1"
    return 2
  fi
  find usr ! -type d | fakeroot tar -cJvf "$1" -T -
}

webserver() {
  python3 -m http.server "$@"
}

# Print specific variable of gcc
parse_gcc_var() {
  [ "$#" -ne 1 ] && return
  # List gcc environment variables
  { printf '\n' | gcc -E -v - >/dev/null; } 2>&1 \
    | awk -v VAR_NAME='^'"${1}" -v FS='=' '$0 ~ VAR_NAME { print $2; }' \
    | awk -v FS=: '{for(i=1;i<NF;i++){print $i};}' \
    | while IFS='' read -r line; do
        realpath "$line"
      done | sort -u
}

# Print LIBRARY_PATH of gcc
gcclib() {
  parse_gcc_var LIBRARY_PATH
}

# Print COMPILER_PATH of gcc
gccpath() {
  parse_gcc_var COMPILER_PATH
}

# Print default include paths
gccinc() {
  printf '\n' | gcc -E -Wp,-v - -fsyntax-only > /dev/null
}

# Make path for each argument and cd into the last path
mkcd() {
  /bin/mkdir -p "$@" && cd "$_" && pwd
}

if command_exist vmhgfs-fuse; then
  # Usage: vmmount /path/to/mount/point
  vmmount() {
    [ "$#" -ne 1 ] && return
    local sharedir
    sharedir="$(vmware-hgfsclient)"
    vmhgfs-fuse -o allow_other -o auto_unmount .host:"$sharedir" "$1"
  }
fi

# If "which" is not an alias and has "-h" option
# shellcheck disable=SC2230
if ! alias which >/dev/null 2>&1; then
  # which command on Debian-based distros lack support for long options
  if command which -h >/dev/null 2>&1; then
    # Use `function` declaration because on "bash 4.2.46(2)-release (x86_64-redhat-linux-gnu)"
    # we have this error:
    #
    #     -bash: /home/lzutao/.aliases: line 108: syntax error near unexpected token `('
    #     -bash: /home/lzutao/.aliases: line 108: `    which() {'
    function which() {
      { alias; declare -f; } \
      | command which --tty-only --read-alias --read-functions --show-tilde --show-dot
    }
  fi
fi

if command_exist xclip; then
  # A shortcut function that simplifies usage of xclip.
  # - Accepts input from either stdin (pipe), or params.
  copy() {
    local scs_col wrn_col reset_col
    # if no tty, data should be available on stdin
    case "$(tty)" in
      /dev/* ) input="$(< /dev/stdin)" ;;
           * ) input="$*";;
    esac
    if [ -z "$input" ]; then  # If no input, print usage message.
      >&2 echo \
        "Copies a string to the clipboard.\n"\
        "Usage: copy <string>\n"\
        "echo <string> | copy"
      return 1
    fi

    scs_col="$(tput setaf 2)"
    wrn_col="$(tput setaf 1)"
    reset_col="$(tput sgr0)"

    # Check user is not root (root doesn't have access to user xorg server)
    if [ "$USER" = "root" ]; then
      >&2 printf '%s\n' "${wrn_col}Must be regular user (not root) to copy a file to the clipboard.${reset_col}"
      return 1
    fi
    # Copy input to clipboard
    printf '%s' "$input" | xclip -selection c
    # Print status.
    >&2 printf '%s\n' "${scs_col}Copied to clipboard.${reset_col}"
  }
fi

# -- Aliases ------------------------------------------------------------------

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias lsport='ss --processes --all --tcp'
alias vi='vim '

if ls --color > /dev/null 2>&1; then # GNU ls support colors
  OS=gnu
elif ls --G > /dev/null 2>&1; then # BSD ls
  OS=bsd
else
  # this maybe OpenBSD
  OS=unknown
fi

[ -f "${HOME}/.aliases" ] && . "${HOME}/.aliases"

# Enable color support of ls
if [ -x /usr/bin/dircolors ]; then
  if [ -f "$HOME/.dircolors" ]; then
    eval "$(dircolors -b "$HOME/.dircolors")"
  else
    eval "$(dircolors -b)"
  fi
fi

alias cdroot='cd "$(git root)"'

if command_exist ctags; then
  # Use "ctags --list-kinds=c" to list all kinds
  alias cproto='ctags --sort=no -x --c-kinds=fp'
fi

if [ $OS = gnu ] || [ $OS = bsd ]; then
  alias ln='ln -iv'
  alias mkdir='mkdir -pv'
  alias mv='mv -iv'
  alias nc='nc -v'
elif [ $OS = unknown ]; then
  alias ln='ln -i'
  alias mkdir='mkdir -p'
  alias mv='mv -i'
fi

alias sudo='sudo '

# if [ -x '/usr/bin/xflock4' ]; then
#  alias suspend='xflock4 && systemctl suspend'
#fi

if command_exist rasm2; then
  alias asm32='rasm2 -a x86 -b 32'
  alias asm64='rasm2 -a x86 -b 64'
  alias disasm32='asm32 -D'
  alias disasm64='asm64 -D'
elif command_exist nasm; then
  # Usage: _assembly 32 'xor eax, eax; mov ebx, eax;'
  _assembly() {
    [ "$#" -ne 2 ] && return
    local infile outfile bits asm
    bits="$1"
    asm="$2"
    outfile='.nasm.bin'
    infile='.nasm.s'
    printf 'BITS %d\n%s\n' "$bits" "$asm" > "$infile" \
    && nasm "$infile" -o "$outfile" \
    && ndisasm -b "$bits" "$outfile"
  }

  alias asm32='_assembly 32'
  alias asm64='_assembly 64'
fi

# Terminal browser Elinks
if command_exist elinks; then
  alias elinks='elinks --no-connect'
fi

if command_exist pngcheck; then
  alias pngcheck='pngcheck -vv'
fi

# for zathura
if command_exist zathura; then
  alias zathura='zathura --fork'
fi

# for evince
if command_exist evince; then
  evince() {
    (command evince "$@" & )
  }
fi

# for audacious
if command_exist audacious; then
  audacious() {
    (command audacious "$@" & )
  }
fi

# Alias that depends on Linux distro
# Note:
#   Use [ -x program ] to test to assure that these programs are actually
#   executable and are the wanted program.
#
# Test for Debian variants
if [ -x '/usr/bin/dpkg' ]; then
  # Perform a simulation of the whole process by:
  #apt-get clean --dry-run
  alias apt4='apt -o Acquire::ForceIPv4=true'
  alias aptshow='apt-cache show' # or `apt show` or `dpkg --print-avail`
  alias dpkglist='dpkg --listfiles' # List files from installed package
  #alias apts='apt-cache search'
  #alias lsapt='apt list --installed'

  #clrapt() {
  #  >&2 printf 'Clearing apt cache ...\n'
  #  sudo apt-get clean
  #}
# Arch Linux
elif [ -x '/bin/pacman' ]; then
  #alias keepping='ping login.net.vn &> /dev/null &'
  alias pacman="pacman --color=auto"
  alias update-grub='grub-mkconfig -o /boot/grub/grub.cfg'
  alias wifioff='nmcli radio wifi off'
  alias wifion='nmcli radio wifi on'
  clrjournal() {
    >&2 printf 'Clearing journal files ...\n'
    command sudo rm -rf /var/log/journal
  }

  clrpac() {
    >&2 printf 'Clearing pacman cache ...\n'
    # remove all packages except for the latest three package versions
    command sudo paccache -rvk3
  }
# for CentOS, RedHat, Fedora
elif [ -x '/usr/bin/yum' ]; then
  clryum() {
    >&2 printf 'Clearing yum cache ...\n'
    command sudo rm -Ifr /var/cache/yum
  }
fi
