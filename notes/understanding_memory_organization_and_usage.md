# Understanding Memory Organization and Usage

### Program Instructions

Program instructions are not stored on the stack. They're stored in a separate memory region called the text segment (or code segment). This region is typically read-only and executable. The instruction pointer (RIP register on x86-64) tracks which instruction to execute next.

The stack is a separate memory region used for:

- Local variables
- Function call management (return addresses, saved registers)
- Temporary data storage

These are completely different memory areas with different purposes and protections.

### Memory Organization

There are three main memory regions:

1. **Text/Code segment**: Contains your program instructions (not on stack)
2. **Data segments**: Global/static variables (.data, .bss sections)
3. **Stack**: Function call frames, local variables, return addresses

Each function call creates a *stack frame* (also called *activation record*) on the stack, but this has nothing to do with where instructions are stored.


### Stack Frame Structure:
A stack frame is a region of the stack dedicated to a single function call. It contains:

High addresses
├──────────────────┐
│ Function params  │ (if >6 params, extras go here)
│ Return address   │ ← Pushed by CALL instruction
│ Saved RBP        │ ← Pushed by function prologue
│ Local variables  │ ← RSP points here (or below)
│ Temp storage     │ ← For intermediate calculations
│ (alignment pad)  │ ← May be needed
└──────────────────┘ ← RSP (stack pointer)
Low addresses (stack grows downward)

#### How RSP Functions:
RSP (Stack Pointer) always points to the top of the stack (lowest address currently in use).

**What moves RSP**:

`push rax` → decrements RSP by 8 bytes, stores RAX at [RSP]
`pop rax` → loads value from [RSP] into RAX, increments RSP by 8 bytes
`sub rsp, 32` → allocates 32 bytes on stack (manual adjustment)
`add rsp, 32` → deallocates 32 bytes
`call` → pushes return address (decrements RSP by 8 bytes)
`ret` → pops return address (increments RSP by 8, bytes)

**RSP vs RBP Relationship**:
RBP (Base Pointer) is optional but conventional:

- Points to a fixed reference point in the current frame
- Remains constant during function execution
- Allows accessing locals/params with fixed offsets

**Typical function prologue**:
```
push rbp          ; Save caller's RBP
mov rbp, rsp      ; Set RBP to current stack top
sub rsp, 32       ; Allocate space for locals
```
Now:

`[rbp-8]` = first local variable
`[rbp-16]` = second local variable
`[rbp+16]` = first argument (if passed on stack)

**Epilogue**:
```
mmov rsp, rbp      ; Restore RSP
pop rbp            ; Restore caller's RBP
ret
```

### Stack Misalignment:
The **System V AMD64 ABI** (used on Linux) requires: **RSP must be 16-byte aligned before any CALL instruction** (RSP % 16 == 0).  Modern instructions (*SSE* / *AVX*) require aligned data. C library functions expect this.

**What is the stack misalignment, what is `RSP` misaligned with?**

The stack is misaligned with the 16-byte boundary requirement of the **System V AMD64 ABI** calling convention. Specifically, before executing a call instruction to any function (especially C library functions), `RSP` must be a multiple of 16 (RSP % 16 == 0).
This requirement exists because SSE/AVX instructions (movaps, movdqa, etc.) require 16-byte aligned memory access.  C library functions may use these instructions internally.  The ABI standardizes this so all code can interoperate safely

**What causes misalignment**:

- `call` pushes 8-byte return address, making RSP misaligned (if it was aligned before)
- Not accounting for pushes/local allocations

**Example problem**:
```
_start:
    ; RSP is 16-byte aligned here (guaranteed by OS)
    call my_function    ; Pushes 8 bytes → RSP now misaligned!
```

Inside my_function:
```
my_function:
    ; RSP is NOT 16-byte aligned (misaligned by 8)
    call printf         ; printf expects aligned stack → CRASH or wrong behavior
```		

Solution - align before calling C functions:
```
my_function:
    push rbp            ; Save RBP (8 bytes)
    mov rbp, rsp        ; Now RSP is 16-byte aligned again!
    sub rsp, 16         ; Allocate space, keep alignment
    
    ; ... your code ...
    
    call printf         ; Safe - RSP is 16-byte aligned
```

**Key rule**: After function prologue (push rbp + mov rbp, rsp), RSP is aligned. Keep allocations in multiples of 16.

**Consequnces of a Misaligned Stack**

There are two potential consequences of a misaligned stack: a general protection fault and silent corruption (wrong results).

*Type 1*: General Protection Fault (most common)
```
call printf       ; RSP misaligned
; Inside printf, might execute:
movaps xmm0, [rsp+16]   ; movaps REQUIRES 16-byte alignment
; → General Protection Fault if [rsp+16] not aligned
```
*Type 2*: Silent corruption/wrong results

- Some functions might work with misalignment but produce incorrect results
- Memory might be accessed at wrong offsets
- Stack unwinding during exceptions fails

*The actual mechanism*:

CPU checks alignment when executing certain instructions (movaps, movdqa, etc.)  If address isn't properly aligned, CPU raises exception
Linux kernel converts this to SIGSEGV (segmentation fault)
Your program crashes.


Note: `movups` (unaligned) works fine, but `movaps` (aligned) requires alignment. You don't control which the C library uses internally.