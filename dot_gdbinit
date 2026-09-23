# ~/.gdbinit : Script file for gdb - GNU Debugger

#set debuginfod enabled off
#source ~/peda/peda.py
# Prefer to manually run context
#set context-sections regs
#gef context.layout ""

# If you compile with -g or at least not stripped
#dir <path/to/source dir>

# Default input offset radix to hexi just like windbg.
set input-radix 16
set disassembly-flavor intel

#start; info proc mapp
set follow-fork-mode parent

# When inspecting large portions of code the scrollbar works better than 'less'
#set pagination off
set height 50

# Keep a history of all the commands typed. Search is possible using ctrl+r
set history save on
set history filename ~/.gdb_history
set history size 32768
set history remove-duplicates unlimited
set history expansion on
set print pretty on

set confirm off

# From <https://stackoverflow.com/a/42741367>.
# The binary strip or without $fp, `info frame` sometimes is wrong about frame.
# Use $rbp at least.
define xbt
  set $xbp = (void **)$arg0
  while 1
    x/2a $xbp
    set $xbp = (void **)$xbp[0]
  end
end

