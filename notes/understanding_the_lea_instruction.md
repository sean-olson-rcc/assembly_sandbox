# Understanding the LEA instruction

The `lea` (Load Effective Address) instruction is one of the most useful and sometimes misunderstood instructions in x86-64 assembly.

## What LEA Does

`lea` calculates an address but **does NOT access memory**. It just does the math and puts the result in a register.

### The Syntax
```assembly
lea destination, [address_expression]
```

### In Your Code:
```assembly
lea r13, [rbp - 800]
```

This means:
- **Calculate** the address `rbp - 800`
- **Store that address** in R13
- **Do NOT** read from or write to memory at that address

## Contrasting LEA with MOV

Let's compare two similar-looking instructions:

```assembly
; Version 1: Using LEA
lea r13, [rbp - 800]    ; R13 = the address (rbp - 800)
                        ; R13 now points to the array

; Version 2: Using MOV (different meaning!)
mov r13, [rbp - 800]    ; R13 = the VALUE stored at address (rbp - 800)
                        ; This reads 8 bytes from memory
```

### Visual Example:

Suppose `rbp = 0x7FFFFFFFE000`

```
Memory Layout:
                        
0x7FFFFFFFE000  ← RBP points here (top of our frame)
    ...
0x7FFFFFFFDF08  ← RBP - 800 = our array starts here
0x7FFFFFFFDF10     [array[0] = some value, e.g., 42]
0x7FFFFFFFDF18     [array[1] = some value, e.g., 17]
    ...
```

With `lea r13, [rbp - 800]`:
```
R13 = 0x7FFFFFFFDF08    ; R13 now holds the ADDRESS
                        ; R13 is a POINTER to the array
```

With `mov r13, [rbp - 800]`:
```
R13 = 42                ; R13 holds the VALUE at that address
                        ; (whatever 8 bytes happen to be there)
```

## Why Use LEA Here?

You need a **pointer** to pass to other functions:

```assembly
lea r13, [rbp - 800]      ; R13 = pointer to array

; Now pass this pointer to input_array
mov rdi, r13              ; RDI = pointer to array (first argument)
mov rsi, 100              ; RSI = max count (second argument)
call input_array          ; input_array receives the pointer
```

Inside `input_array`, when it does:
```cpp
array_ptr[0] = value;     // Writes to address in array_ptr
```

It's writing to the memory location `0x7FFFFFFFDF08` that R13 pointed to!

## LEA as a Calculator

`lea` is also used as a clever way to do math without using memory:

```assembly
; Multiply by 3 without MUL
lea rax, [rbx + rbx*2]    ; RAX = RBX + RBX*2 = RBX * 3

; Add a constant
lea rax, [rbx + 100]      ; RAX = RBX + 100

; Complex calculation
lea rax, [rbx + rcx*4 + 8] ; RAX = RBX + (RCX * 4) + 8
```

But in your code, it's simply calculating the starting address of your array on the stack.

## Summary

```assembly
lea r13, [rbp - 800]
```

Means: "Calculate where my array starts (800 bytes below RBP) and put that **address** in R13 so I can use it as a pointer."

It's the assembly equivalent of:
```cpp
int64_t* r13 = &array[0];  // Get the address of array
```

Does that clarify how `lea` works?