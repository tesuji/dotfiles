### pretty print type/struct offset

```
ptype /o struct _IO_FILE
```

### load source code to step into

```
$ wget https://ftp.gnu.org/gnu/glibc/glibc-2.27.tar.gz
$ tar -xvf glibc-2.27.tar.gz
Run the binary in GDB and set a breakpoint anywhere (or CTRL + C)
(gdb) dir path/to/glibc-2.27/libio/
```

### use `start` to run program until main function
`ctrl-x-a` to run tui mode
`ctrl-x-2` second windows, cycle through

```gdb
(gdb-peda) dumprop
(gdb-peda) tracecall
```

to run python within gdb

```gdb
(gdb) python
> print('hello world')
> end
hello world
```

another way

```gdb
(gdb) python gdb.execute('start')
(gdb) python gdb.parse\_and\_eval('next')
```

type command for breakpoint

```gdb
(gdb) command n
> record
> continue
> watch foo # stop when foo is modified
> watch -l foo # watch location of foo
> rwatch foo # stop when foo is read
> watch foo if foo > 10 # stop when foo is 10
> end
```

run command for breakpoint n

to reverse step: `(gdb) reverse-step`

to examine variable: `(gdb) x $4`

```gdb
# ~/.gdbinit
set pagination off
set confirm off
set history save on
set print pretty on
```

## allow us to get rid of for loop

until

## examine backstrace

(gdb) bt

## use catch point to catch event in your program

```gdb
(gdb) catch catch # to catch C++ exception
(gdb) catch syscall sleep # to stop when calling sleep() syscall
(gdb) catch syscall 100 # stop when calling 100th syscall
(gdb) catch syscall ptrace # workaround anti-debugging
commands 1
set ($eax) = 0
continue
end
```

## to save your breakpoints

```gdb
(gdb) save breakpoint
(gdb) info line * $pc # if gcc -g
```

## to run function by address

```gdb
(gdb) call ((int*())*0x40154f)(10, 5)
$1 = (int *) 0x5
(gdb)
```
