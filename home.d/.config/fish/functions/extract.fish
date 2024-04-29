# Usage: extract <file>
# Description: extracts archived files / mounts disk images
# Note: .dmg/hdiutil is macOS-specific.
#
# Credit: http://nparikh.org/notes/zshrc.txt
function extract
  set lower_name (string lower "$argv[1]")
  switch $lower_name
    case '*'.tar '*'.x
      tar -xvf $argv
    case '*'.tar.bz2 '*'.tbz2
      tar -xjvf $argv
    case '*'.tar.xz
      tar -xJvf $argv
    case '*'.tar.gz '*'.tgz
      tar -xzvf $argv
    case '*'.tar.lzma
      tar --lzma -xvf $argv
    case '*'.bz2
      bunzip2 $argv
    case '*'.xz
      unxz $argv
    case '*'.gz
      gunzip -k $argv
    case '*'.zip
      unzip $argv
    case '*'.rar
      unrar x $argv
    case '*'.7z
      7z e $argv
    case '*'.z
      uncompress $argv
    case '*'.deb
      dpkg --extract $argv
    case '*'
      printf '"%s" cannot be extracted via extract()\n' "$argv[1]"
      return 1
  end
end
