# ~/.gdbinit : Script file for gdb - GNU Debugger

#source ~/peda/peda.py

set disassembly-flavor intel

#start; info proc mapp
#set follow-fork-mode child

# When inspecting large portions of code the scrollbar works better than 'less'
set pagination off

# Keep a history of all the commands typed. Search is possible using ctrl+r
set history save on
set history filename ~/.gdb_history
set history size 32768
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

# set context-sections regs
