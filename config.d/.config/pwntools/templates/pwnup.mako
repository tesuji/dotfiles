<%page args="binary, host=None, port=None, user=None, password=None, libc=None, remote_path=None, quiet=False"/>\
<%
import os
import sys

from pwnlib.context import context as ctx
from pwnlib.elf.elf import ELF
from pwnlib.util.sh_string import sh_string
from elftools.common.exceptions import ELFError

argv = list(sys.argv)
argv[0] = os.path.basename(argv[0])

try:
    if binary:
       ctx.binary = ELF(binary, checksec=False)
except ELFError:
    pass

if not binary:
    binary = './path/to/binary'

exe = os.path.basename(binary)

ssh = user or password
if ssh and not port:
    port = 22
elif host and not port:
    port = 4141

remote_path = remote_path or exe
password = password or 'secret1234'
binary_repr = repr(binary)
libc_repr = repr(libc)
%>\
#!/usr/bin/env python3
from pwn import *
sys.tracebacklimit = 4
context(endian = "little", encoding='utf-8') # arch='amd64'
# Use pwntools-terminal which loads nix env to the new tmux pane.
#context.terminal = ["tmux", "splitw", "-v"]
const = constants

# quick functions
def pwninit():
    ELF.base = ELF.address
    tube.s = tube.send
    tube.sa = tube.sendafter
    tube.sl = tube.sendline
    tube.sla = tube.sendlineafter
    tube.rcu = tube.recvuntil
    pass
pwninit()
%if ctx.binary or not host:

libc_path = ${libc_repr}
exe_path = args.EXE or ${binary_repr}
exe = context.binary = ELF(exe_path, checksec=False)
with context.silent:
    if b"musl" in exe.linker:
        libc = ELF(libc_path, checksec=False)
    elif exe.arch not in ['amd64', 'i386'] or (args.REMOTE and libc_path):
        libc = ELF(libc_path, checksec=False)
    elif libc := exe.libc: libc.address = 0
    pass
<% binary_repr = 'exe.path' %>
%else:
context.update(arch='i386')
exe = ${binary_repr}
<% binary_repr = 'exe' %>
%endif
BAD_CHARS = string.whitespace.encode()

%if host:
host = args.HOST or ${repr(host)}
%endif
%if port:
port = int(args.PORT or ${port})
%endif
%if user:
user = args.USER or ${repr(user)}
password = args.PASSWORD or ${repr(password)}
%endif
%if ssh:
remote_path = ${repr(remote_path)}
%endif
%if ssh:

# Connect to the remote SSH server
shell = None
if not args.LOCAL:
    shell = ssh(user, host, port, password)
    shell.set_working_directory(symlink=True)
%endif

def u64(b): return packing.u64(b.ljust(8, b'\0'))

def log_leak(**kwargs):
    for name, value in kwargs.items():
        info(f"LEAK: {name:16} = {value:#x}")

def log_calc(**kwargs):
    for name, value in kwargs.items():
        info(f"CALC: {name:16} = {value:#x}")

def gdb_pause(interactive=False):
    if args.REMOTE: return
    d = r.clean(0.1)
    pid = r.pid if hasattr(r, 'pid') else -1
    input(f'gdb {pid}')
    if interactive: r.interactive()
    r.unrecv(d)

def conn(argv=[]):
    if args.REMOTE:
        r = remote(host, int(port), ssl=args.SSL)
    elif args.DOCKER:
        r = remote('localhost', int(1337))
    elif args.GDB:
        r = gdb.debug(argv or [exe_path], exe=exe_path, gdbscript=gdbscript)
    else:
        r = process(argv or [exe_path])
    return r

PROMPT = b'> '
def cmd(n):
    r.rcu(PROMPT)
    out = str(n) if isinstance(n, int) else n
    r.sl(out)

#             EXPLOIT GOES HERE               #

gdbscript = """\
c
"""

if libc:
    libc.sym['binsh'] = next(libc.search(b'/bin/sh\0'))
    # libc.sym['trap'] = next(libc.search(b'\xcc', executable=True))

r = conn()
def main():
    global r
    pass

try:
    main()
    if hasattr(r, 'pid'): print(f'pid = {r.pid}')
    r.interactive()
except Exception as exc:
    raise exc
