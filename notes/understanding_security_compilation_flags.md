# Security-Related Compilation Flags Reference
## Understanding `-no-pie` and `-z noexecstack`

---

## Table of Contents

1. [Overview](#overview)
2. [`-no-pie` (Position Independent Executable)](#-no-pie-position-independent-executable)
3. [`-z noexecstack` (Non-Executable Stack)](#-z-noexecstack-non-executable-stack)
4. [Practical Usage](#practical-usage)
5. [Checking Your Executable](#checking-your-executable)
6. [Summary and Recommendations](#summary-and-recommendations)

---

## Overview

These are security-related flags that deal with how modern operating systems protect against certain types of attacks. Both flags are used during the linking stage of the build process.

| Flag | Stage | Purpose | Default (Modern) |
|------|-------|---------|------------------|
| `-no-pie` | Link | Disable address randomization | PIE enabled |
| `-z noexecstack` | Link | Make stack non-executable | Non-executable |

---

## `-no-pie` (Position Independent Executable)

### What It Does

This flag disables Position Independent Executable (PIE) generation, which means your program will load at a fixed, predictable memory address rather than a random one.

### Which Toolchain Uses It

- **Linking stage only** (gcc/g++, not ld directly with this syntax)
- For ld directly, you'd use `-no-pie` or `--no-dynamic-linker` depending on what you want

### Technical Background

**With PIE (default on modern systems):**
```
Program loads at: 0x5627a3f12000  (random address)
Next run:        0x55e9c2a01000  (different!)
```

**With `-no-pie`:**
```
Program loads at: 0x400000  (fixed address, predictable)
Every run:       0x400000  (always the same)
```

This randomization is called **ASLR** (Address Space Layout Randomization) - a security feature that makes it harder for attackers to exploit memory corruption bugs.

### Why You Might Need It for Assembly

Assembly programs often have issues with PIE because:

1. **Absolute addressing** - Assembly code might use fixed memory addresses
2. **Simpler to debug** - Addresses don't change between runs
3. **Learning purposes** - Easier to understand what's happening

**Example where PIE causes problems:**
```asm
section .data
    msg db "Hello", 0

section .text
global main
main:
    mov rdi, msg        ; This assumes msg is at a known address
    call printf
    ret
```

With PIE, `msg` doesn't have a fixed address, so you need position-independent code:
```asm
    lea rdi, [rel msg]  ; Position-independent addressing
```

### Cautions

**Security concerns:**
- `-no-pie` makes your program slightly less secure against certain exploits
- For production/released software, you generally want PIE enabled
- For learning and debugging assembly, `-no-pie` is often easier

**When to use:**
- Assembly programs using absolute addressing
- Debugging (predictable addresses)
- Educational purposes
- When your assembly isn't written for position independence

**When NOT to use:**
- Production software (security risk)
- When you can write position-independent code

---

## `-z noexecstack` (Non-Executable Stack)

### What It Does

This controls whether the program's stack memory region can execute code.

- **`-z noexecstack`** - Stack is NOT executable (safer, default on modern systems)
- **`-z execstack`** - Stack IS executable (dangerous, legacy compatibility)

### Which Toolchain Uses It

- **Linking stage only**
- Passed to the linker (ld) via gcc/g++
- Format: `-Wl,-z,noexecstack` when using gcc/g++
- Or directly: `-z noexecstack` with ld

### Technical Background

In the bad old days, some programs would:
1. Generate machine code on the stack at runtime
2. Jump to that code and execute it

This was used for:
- Trampolines in nested functions
- Just-in-time compilation tricks
- Some legitimate but unusual patterns

**But attackers also use executable stacks:**
- Buffer overflow attack overwrites stack
- Places malicious code on stack
- Jumps to it and executes it

**Modern protection (NX bit):**
Modern CPUs support marking memory regions as "no execute". An executable stack is a huge security hole.

### Why This Matters for Assembly

By default, if your assembly code doesn't explicitly mark the stack as non-executable, the linker might make it executable for compatibility:

```bash
# Check if stack is executable
readelf -l program | grep GNU_STACK

# Non-executable stack (good):
GNU_STACK      0x000000 0x0000000000000000 0x0000000000000000
               0x000000 0x000000 RW  0x10

# Executable stack (bad):
GNU_STACK      0x000000 0x0000000000000000 0x0000000000000000
               0x000000 0x000000 RWE 0x10
               # Note the 'E' for executable ^^^
```

### The Fix in Assembly

**Option 1: Add to your `.asm` files:**
```asm
section .note.GNU-stack noalloc noexec nowrite progbits
```

**Option 2: Use the linker flag:**
```bash
gcc -Wl,-z,noexecstack main.o util.o -o program
```

### Cautions

**Always use `-z noexecstack` unless:**
- You have a very specific reason to execute code on the stack
- You're working with legacy code that requires it

**Security implications:**
- Executable stacks are a major security vulnerability
- Modern systems default to non-executable stacks
- No legitimate modern program should need an executable stack

**When you might see warnings:**
```
warning: /tmp/ccXXXX.o: missing .note.GNU-stack section implies executable stack
```

This means one of your object files didn't specify stack permissions, and the linker is being cautious.

---

## Practical Usage

### For Your Assembly Programs

**Compilation (no flags needed at this stage):**
```bash
yasm -f elf64 -g dwarf2 program.asm -o program.o
```

**Linking:**
```bash
# If you need both flags
gcc -m64 -no-pie -Wl,-z,noexecstack program.o -o program
```

**Or in your assembly files, add:**
```asm
section .note.GNU-stack noalloc noexec nowrite progbits
```

Then you don't need the linker flag for stack protection.

### Makefile Example

```makefile
AS = yasm
ASFLAGS = -f elf64 -g dwarf2
CC = gcc
LDFLAGS = -m64 -no-pie -Wl,-z,noexecstack

SOURCES = main.asm util.asm
OBJECTS = $(SOURCES:.asm=.o)
TARGET = program

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $(TARGET)

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET)

.PHONY: all clean
```

---

## Checking Your Executable

### Check for PIE

```bash
# Simple check
file program
# PIE: "dynamically linked ... (uses shared libs)"
# Non-PIE: "statically linked" or "ELF 64-bit LSB executable"

# More specific check
readelf -h program | grep Type
# PIE: Type: DYN (Shared object file)
# Non-PIE: Type: EXEC (Executable file)
```

### Check Stack Permissions

```bash
readelf -l program | grep GNU_STACK
# RW  = Read/Write (good - non-executable)
# RWE = Read/Write/Execute (bad - executable stack)
```

**Example output (non-executable stack - good):**
```
  GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000000 0x0000000000000000  RW   0x10
```

**Example output (executable stack - bad):**
```
  GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000000 0x0000000000000000  RWE  0x10
```

### Using checksec (if installed)

```bash
checksec --file=program

# Output will show:
# PIE: Enabled/Disabled
# NX: Enabled/Disabled (NX = No eXecute on stack)
```

---

## Summary and Recommendations

### Quick Reference Table

| Flag | Stage | Purpose | Default | Recommendation |
|------|-------|---------|---------|----------------|
| `-no-pie` | Link | Disable address randomization | PIE on (modern) | Use for assembly learning, avoid in production |
| `-z noexecstack` | Link | Make stack non-executable | Usually non-exec | Always use (or add section to .asm) |

### Best Practices

**For Learning/Development:**
```bash
# Assembly programs during learning
gcc -m64 -no-pie -Wl,-z,noexecstack program.o -o program
```

**For Production:**
```bash
# Omit -no-pie, keep security features
gcc -m64 -Wl,-z,noexecstack program.o -o program

# Or better, write position-independent assembly
# and add .note.GNU-stack section to .asm files
```

### Writing Position-Independent Assembly

Instead of using `-no-pie`, learn to write position-independent code:

**Bad (requires -no-pie):**
```asm
mov rdi, my_string      ; Absolute address
```

**Good (works with PIE):**
```asm
lea rdi, [rel my_string]  ; Relative address
```

### Adding Stack Protection to Assembly Files

Add this line at the end of every `.asm` file:

```asm
section .note.GNU-stack noalloc noexec nowrite progbits
```

This explicitly marks the stack as non-executable, eliminating the need for the `-z noexecstack` linker flag.

---

## Final Thoughts

### Key Takeaways

1. **`-no-pie`**: Convenient for assembly learning, but understand it's a security tradeoff
   - Makes debugging easier (predictable addresses)
   - Reduces security (disables ASLR)
   - Acceptable for learning, avoid in production

2. **`-z noexecstack`**: Should basically always be used
   - There's no good reason for an executable stack in modern code
   - Protects against buffer overflow attacks
   - Can be set via linker flag or assembly section directive

3. **Best approach**: Learn to write position-independent assembly code so you can avoid `-no-pie` entirely

### Additional Resources

**Check your system defaults:**
```bash
# See if PIE is default on your system
gcc -v 2>&1 | grep -i pie

# Check GCC's default specs
gcc -dumpspecs | grep -A 2 pie
```

**Useful commands:**
```bash
readelf -h program           # View ELF header (check Type)
readelf -l program           # View program headers (check GNU_STACK)
objdump -d program           # Disassemble to see actual addresses
checksec --file=program      # Comprehensive security check
```

---

*Understanding these flags helps you make informed decisions about security vs. convenience tradeoffs in your build process.*