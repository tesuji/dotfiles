# About calling convention on some system

The calling convention of the **System V AMD64 ABI** is followed on Solaris,
Linux, FreeBSD, macOS, and is the de facto standard among Unix and Unix-like
operating systems. The first six integer or pointer arguments are passed in
registers **RDI RSI RDX RCX R8 R9** (**R10** is used as a static chain pointer
in case of nested functions), while **XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6**
and **XMM7** are used for certain floating point arguments. As in the
Microsoft x64 calling convention, additional arguments are passed on the stack
and the return value is stored in **RAX** and **RDX**.

If the ***callee*** wishes to use registers **RBP**, **RBX**, and **R12-R15**,
it must restore their original values before returning control to the ***caller***.
All other registers must be saved by the ***caller*** if it wishes to preserve
their values.

If the ***callee*** is a variadic function, then the number of floating point
arguments passed to the function in vector registers must be provided by
the ***caller*** in the **RAX** register.

Unlike the Microsoft calling convention, a shadow space is not provided;
on function entry, the return address is adjacent to the seventh integer
argument on the stack.
