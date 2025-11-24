# Build Toolchain Reference Guide
## Compilers, Assemblers, Linkers, and Flags for Makefile Development

---

## Table of Contents

1. [Overview of the Build Process](#1-overview-of-the-build-process)
2. [Compiler and Assembler Invocation](#2-compiler-and-assembler-invocation)
3. [Common Compilation and Assembly Flags](#3-common-compilation-and-assembly-flags)
4. [The Linking Stage](#4-the-linking-stage)
5. [Common Linker Flags](#5-common-linker-flags)
6. [Practical Examples by Project Type](#6-practical-examples-by-project-type)
7. [Dependency Management in Makefiles](#7-dependency-management-in-makefiles)

---

## 1. Overview of the Build Process

### The Three-Stage Pipeline

Building an executable from source code typically involves three stages:

```
Source Files (.asm, .c, .cpp)
         ↓
    [COMPILE/ASSEMBLE]
         ↓
    Object Files (.o)
         ↓
      [LINK]
         ↓
    Executable (a.out, program)
```

### What Happens at Each Stage

**Stage 1: Preprocessing (C/C++ only)**
- Handles `#include`, `#define`, `#ifdef` directives
- Expands macros
- Removes comments
- Produces pure C/C++ code (not usually saved to disk)

**Stage 2: Compilation/Assembly**
- **For C files (.c):** gcc compiles to assembly, then assembles to object code
- **For C++ files (.cpp):** g++ compiles to assembly, then assembles to object code
- **For Assembly files (.asm):** yasm/nasm directly assembles to object code
- Produces relocatable object files (.o) with:
  - Machine code for each function
  - Symbol table (exported and imported symbols)
  - Relocation information (addresses that need fixing during linking)

**Stage 3: Linking**
- Combines multiple object files
- Resolves symbol references (connects function calls to function definitions)
- Assigns final memory addresses
- Includes library code (static or marks for dynamic linking)
- Adds runtime startup code (for C/C++ programs)
- Produces final executable

### Key Insight: Two-Pass Flexibility

Most build systems separate compilation and linking into distinct steps. This allows:
- Rebuilding only changed source files
- Mixing different source languages
- Creating libraries that can be reused
- Faster incremental builds

---

## 2. Compiler and Assembler Invocation

### 2.1 YASM (Assembly Language Assembler)

**Basic Syntax:**
```bash
yasm [options] source.asm
```

**What YASM Does:**
- Reads assembly language source code
- Translates mnemonics to machine code
- Creates an object file with symbol table and relocation info
- Does NOT link (you need a linker for that)

**Typical Invocation:**
```bash
yasm -f elf64 -g dwarf2 source.asm -o source.o
```

**Key YASM Options:**

| Flag | Purpose | When to Use |
|------|---------|-------------|
| `-f elf64` | Output format (64-bit ELF) | Always on x86-64 Linux |
| `-f elf32` | Output format (32-bit ELF) | For 32-bit targets |
| `-g dwarf2` | Debug info format | During development for gdb |
| `-l listing.lst` | Generate listing file | To see generated machine code |
| `-o file.o` | Output filename | Specify where object file goes |
| `-D SYMBOL` | Define a symbol | Conditional assembly |
| `-I path/` | Include path | For %include directives |

### 2.2 NASM (Alternative Assembly Assembler)

**Basic Syntax:**
```bash
nasm [options] source.asm
```

**Typical Invocation:**
```bash
nasm -f elf64 -g -F dwarf source.asm -o source.o
```

**Key Differences from YASM:**
- Syntax: `-F dwarf` instead of `-g dwarf2`
- Slightly different macro system
- Generally interchangeable for basic programs
- YASM is more compatible with NASM syntax

### 2.3 GCC (GNU C Compiler)

**Basic Syntax:**
```bash
gcc [options] source.c
```

**What GCC Does:**
GCC is actually a "driver" that coordinates multiple tools:
1. Preprocessor (cpp) - handles #include, #define
2. Compiler (cc1) - translates C to assembly
3. Assembler (as) - translates assembly to object code
4. Linker (ld) - combines object files (when linking)

**Typical Compilation (No Linking):**
```bash
gcc -c -Wall -g source.c -o source.o
```

**Typical Compilation and Linking:**
```bash
gcc -Wall -g source.c -o program
```

**Key GCC Options:**

| Flag | Purpose | When to Use |
|------|---------|-------------|
| `-c` | Compile only, don't link | When building object files |
| `-o file` | Output filename | Always (otherwise defaults to a.out) |
| `-Wall` | Enable all warnings | Always - catches common errors |
| `-Wextra` | Even more warnings | Recommended for quality code |
| `-Werror` | Treat warnings as errors | For strict builds |
| `-g` | Include debug symbols | During development |
| `-O0` | No optimization | Default, best for debugging |
| `-O1, -O2, -O3` | Optimization levels | For release builds |
| `-Os` | Optimize for size | For embedded/size-constrained |
| `-std=c99` | C standard version | Specify language standard |
| `-std=c11` | C11 standard | Modern C features |
| `-I path/` | Include search path | For header files |
| `-D MACRO` | Define preprocessor macro | Conditional compilation |
| `-m64` | 64-bit target | Usually default on 64-bit systems |
| `-m32` | 32-bit target | For 32-bit builds on 64-bit system |
| `-fPIC` | Position Independent Code | Required for shared libraries |
| `-shared` | Create shared library | When making .so files |

### 2.4 G++ (GNU C++ Compiler)

**Basic Syntax:**
```bash
g++ [options] source.cpp
```

**What G++ Does:**
Same driver model as GCC, but:
- Uses C++ compiler (cc1plus) instead of C compiler
- Automatically links C++ standard library (libstdc++)
- Handles C++ name mangling
- Knows about C++ features (classes, templates, etc.)

**Typical Compilation (No Linking):**
```bash
g++ -c -Wall -g source.cpp -o source.o
```

**Typical Compilation and Linking:**
```bash
g++ -Wall -g source.cpp -o program
```

**Key G++ Options:**

Most flags are identical to GCC, with these additions:

| Flag | Purpose | When to Use |
|------|---------|-------------|
| `-std=c++98` | C++98 standard | Legacy code |
| `-std=c++11` | C++11 standard | Modern C++ features |
| `-std=c++14` | C++14 standard | More modern features |
| `-std=c++17` | C++17 standard | Current recommended |
| `-std=c++20` | C++20 standard | Latest features |
| `-stdlib=libstdc++` | Use GNU C++ library | Default on Linux |
| `-fno-exceptions` | Disable exceptions | Embedded/performance critical |
| `-fno-rtti` | Disable runtime type info | Size/performance optimization |

### Important Note: GCC vs G++ for Linking

When **linking** (not just compiling):
- **Use gcc** if your program is primarily C (even with .asm files calling C libraries)
- **Use g++** if your program has any C++ code
- Why? The linker needs to include the right runtime libraries:
  - gcc links with libc (C standard library)
  - g++ links with libc AND libstdc++ (C++ standard library)

---

## 3. Common Compilation and Assembly Flags

### 3.1 Flags Organized by Purpose

#### Debug vs Release Builds

**Debug Build Flags:**
```bash
-g              # Include debug symbols for gdb
-O0             # No optimization (default)
-DDEBUG         # Define DEBUG macro
-Wall -Wextra   # Show all warnings
```

**Release Build Flags:**
```bash
-O2             # Moderate optimization (recommended)
-O3             # Aggressive optimization
-DNDEBUG        # Define NDEBUG (disables assert())
-s              # Strip debug symbols (at link stage)
```

#### Architecture and Platform

```bash
-m64            # Target 64-bit x86-64
-m32            # Target 32-bit x86
-march=native   # Optimize for current CPU
-march=x86-64   # Generic x86-64 compatible code
```

#### Code Generation

```bash
-fPIC           # Position Independent Code (for shared libraries)
-fno-pie        # Disable Position Independent Executable
-static         # Static linking (embed all libraries)
```

#### Include Paths and Definitions

```bash
-I /path/to/headers     # Add include search path
-D SYMBOL               # Define SYMBOL (like #define SYMBOL)
-D SYMBOL=value         # Define with value
-U SYMBOL               # Undefine SYMBOL
```

#### Language Standards

```bash
# C Standards
-std=c89        # ANSI C (very old)
-std=c99        # C99 (widely supported)
-std=c11        # C11 (modern)
-std=c17        # C17 (current)

# C++ Standards
-std=c++11      # C++11 (minimum modern)
-std=c++14      # C++14
-std=c++17      # C++17 (recommended)
-std=c++20      # C++20 (latest)
```

### 3.2 Warning Flags (Important for Quality)

```bash
-Wall           # Enable most common warnings
-Wextra         # Additional warnings beyond -Wall
-Wpedantic      # Strict ISO C/C++ compliance warnings
-Werror         # Treat all warnings as errors
-Wformat=2      # Check printf/scanf format strings
-Wconversion    # Warn about implicit type conversions
-Wshadow        # Warn if variable shadows another
```

**Recommended Warning Set:**
```bash
-Wall -Wextra -Wpedantic
```

### 3.3 Optimization Levels

| Level | Description | When to Use |
|-------|-------------|-------------|
| `-O0` | No optimization | Debugging (default) |
| `-O1` | Basic optimization | Initial testing |
| `-O2` | Moderate optimization | **Recommended for release** |
| `-O3` | Aggressive optimization | Performance critical (may increase size) |
| `-Os` | Optimize for size | Embedded systems |
| `-Ofast` | -O3 + fast math (non-standard) | Only if you know what you're doing |

**Key Point:** Always test with the same optimization level you'll release with. `-O2` and `-O3` can expose bugs that don't appear at `-O0`.

### 3.4 Assembly-Specific Flags (YASM)

```bash
-f elf64        # 64-bit ELF format (Linux)
-f elf32        # 32-bit ELF format
-f win64        # 64-bit Windows
-g dwarf2       # DWARF2 debug format
-l listing.lst  # Generate assembly listing
-p nasm         # Use NASM preprocessor (default)
-I path/        # Include file search path
```

---

## 4. The Linking Stage

### 4.1 What is Linking?

Linking is the process of:
1. Combining multiple object files (.o) into one executable
2. Resolving symbol references (connecting function calls to definitions)
3. Assigning final memory addresses to code and data
4. Including necessary library code
5. Setting up the program entry point

### 4.2 Three Ways to Link

#### Option 1: Direct LD (Bare Metal)

```bash
ld [options] file1.o file2.o -o program
```

**When to use:** Pure assembly programs with no C runtime or libraries.

**Challenges:**
- Must manually specify C runtime files (crt1.o, crti.o, crtn.o)
- Must specify dynamic linker path
- Must provide all library paths
- Very tedious for anything beyond bare metal

**Example (pure assembly, no libraries):**
```bash
ld -m elf_x86_64 program.o -o program
```

#### Option 2: Link with GCC

```bash
gcc [options] file1.o file2.o -o program
```

**When to use:** 
- Any program calling C library functions (printf, malloc, etc.)
- Mixed C and assembly
- Pure C programs

**What GCC adds automatically:**
- C runtime startup files
- Links with libc (C standard library)
- Specifies dynamic linker
- Sets up proper calling conventions

**Example:**
```bash
gcc -m64 program.o util.o -o program
```

#### Option 3: Link with G++

```bash
g++ [options] file1.o file2.o -o program
```

**When to use:**
- Any program with C++ code
- Mixed C++, C, and assembly
- When you need C++ standard library

**What G++ adds automatically:**
- Everything GCC adds, PLUS
- Links with libstdc++ (C++ standard library)
- Handles C++ name mangling
- Includes C++ runtime support

**Example:**
```bash
g++ -m64 program.o util.o math.o -o program
```

### 4.3 Decision Tree: Which Linker to Use?

```
Does your program have ANY C++ code (.cpp files)?
├─ YES → Use g++
└─ NO → Does it call C library functions (printf, malloc, etc.)?
    ├─ YES → Use gcc
    └─ NO → Pure assembly only?
        ├─ YES → Can use ld directly
        └─ Probably still use gcc for simplicity
```

### 4.4 Static vs Dynamic Linking

**Dynamic Linking (Default):**
```bash
gcc program.o -o program
# Creates executable that loads libraries at runtime
```

- Smaller executable
- Shares library code with other programs
- Can update libraries without recompiling
- Requires libraries present at runtime

**Static Linking:**
```bash
gcc -static program.o -o program
# Embeds all library code into executable
```

- Larger executable
- No external dependencies
- Portable across systems
- Cannot update libraries without recompiling

### 4.5 Creating Shared Libraries

A shared library (.so on Linux, .dll on Windows, .dylib on macOS) is code that can be shared by multiple programs.

**Creating a shared library:**
```bash
# Step 1: Compile with -fPIC (Position Independent Code)
gcc -c -fPIC util.c -o util.o
yasm -f elf64 asm_util.asm -o asm_util.o

# Step 2: Link into shared library
gcc -shared util.o asm_util.o -o libutil.so
```

**Using a shared library:**
```bash
# Option 1: Link by name (requires library in standard location)
gcc program.o -lutil -o program

# Option 2: Link by path
gcc program.o -L. -lutil -o program

# Option 3: Link directly with the .so file
gcc program.o libutil.so -o program
```

**Why -fPIC?** Shared libraries must be "position independent" because they can be loaded at any memory address. The code must not depend on being at a specific location.

---

## 5. Common Linker Flags

### 5.1 Essential Linker Flags

| Flag | Purpose | Example |
|------|---------|---------|
| `-o file` | Output filename | `-o program` |
| `-L path/` | Add library search path | `-L/usr/local/lib` |
| `-l name` | Link with library | `-lm` links with libm.so |
| `-static` | Static linking | Embed all libraries |
| `-shared` | Create shared library | Make a .so file |
| `-m64` | 64-bit linking | Match your object files |
| `-m32` | 32-bit linking | For 32-bit programs |

### 5.2 Library Linking

**Understanding -l flag:**
```bash
-lm      # Links with libm.so (math library)
-lpthread # Links with libpthread.so (POSIX threads)
-lutil   # Links with libutil.so (your custom library)
```

The pattern: `-lNAME` → searches for `libNAME.so` (or `libNAME.a` for static)

**Library Search Order:**
1. Paths specified with `-L`
2. Standard system paths (`/usr/lib`, `/usr/local/lib`)
3. Paths in `LD_LIBRARY_PATH` environment variable

**Example:**
```bash
gcc program.o -L./lib -lmylib -lm -o program
# Searches ./lib first for libmylib.so, then standard paths
# Links with math library (libm.so) from standard location
```

### 5.3 Symbol Control

```bash
-s              # Strip all symbols (smaller executable)
-Wl,--strip-all # Same as -s
-rdynamic       # Export all symbols for dynamic loading
```

### 5.4 Runtime Library Path

When you create executables that use shared libraries in non-standard locations:

```bash
# Set runtime library search path
gcc program.o -L./lib -lmylib -Wl,-rpath,./lib -o program
```

The `-Wl,-rpath,./lib` tells the executable to look in `./lib` for libraries at runtime.

### 5.5 Passing Flags Directly to LD

GCC/G++ use `-Wl,` to pass flags directly to the linker:

```bash
-Wl,--flag            # Pass single flag to ld
-Wl,--flag,value      # Pass flag with value to ld
-Wl,--flag1,--flag2   # Pass multiple flags (comma-separated)
```

**Common uses:**
```bash
-Wl,-rpath,/path      # Set runtime library path
-Wl,--strip-all       # Strip symbols
-Wl,-Map,output.map   # Generate linker map file
```

### 5.6 Typical Linking Command Patterns

**Simple executable:**
```bash
gcc -m64 main.o util.o -o program
```

**With math library:**
```bash
gcc -m64 main.o -lm -o program
```

**With custom shared library:**
```bash
gcc -m64 main.o -L./lib -lmyutil -Wl,-rpath,./lib -o program
```

**Static linking:**
```bash
gcc -m64 -static main.o util.o -o program
```

**Creating shared library:**
```bash
gcc -shared -fPIC util.o helpers.o -o libutil.so
```

---

## 6. Practical Examples by Project Type

### 6.1 Case 1: Pure Assembly (No C Runtime)

**Project Structure:**
```
project/
├── main.asm
├── util.asm
└── Makefile
```

**Build Commands:**
```bash
# Assemble
yasm -f elf64 -g dwarf2 main.asm -o main.o
yasm -f elf64 -g dwarf2 util.asm -o util.o

# Link with ld (bare metal)
ld -m elf_x86_64 main.o util.o -o program
```

**Makefile Pattern:**
```makefile
AS = yasm
ASFLAGS = -f elf64 -g dwarf2
LD = ld
LDFLAGS = -m elf_x86_64

SOURCES = main.asm util.asm
OBJECTS = $(SOURCES:.asm=.o)
TARGET = program

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(LD) $(LDFLAGS) $(OBJECTS) -o $(TARGET)

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET)
```

**Notes:**
- No C library functions (no printf, no malloc)
- Must use system calls directly (int 0x80 or syscall)
- Entry point is `_start`, not `main`
- Must manually call `exit` system call

### 6.2 Case 2: Pure C Program

**Project Structure:**
```
project/
├── main.c
├── util.c
├── util.h
└── Makefile
```

**Build Commands:**
```bash
# Compile
gcc -c -Wall -g -std=c11 main.c -o main.o
gcc -c -Wall -g -std=c11 util.c -o util.o

# Link
gcc -m64 main.o util.o -o program
```

**Makefile Pattern:**
```makefile
CC = gcc
CFLAGS = -Wall -Wextra -g -std=c11
LDFLAGS = -m64

SOURCES = main.c util.c
OBJECTS = $(SOURCES:.c=.o)
TARGET = program

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET)

.PHONY: all clean
```

**Notes:**
- Use gcc for both compiling and linking
- `-Wall -Wextra` catch most common mistakes
- Entry point is `main` (C runtime sets this up)

### 6.3 Case 3: Pure C++ Program

**Project Structure:**
```
project/
├── main.cpp
├── util.cpp
├── util.hpp
└── Makefile
```

**Build Commands:**
```bash
# Compile
g++ -c -Wall -g -std=c++17 main.cpp -o main.o
g++ -c -Wall -g -std=c++17 util.cpp -o util.o

# Link
g++ -m64 main.o util.o -o program
```

**Makefile Pattern:**
```makefile
CXX = g++
CXXFLAGS = -Wall -Wextra -g -std=c++17
LDFLAGS = -m64

SOURCES = main.cpp util.cpp
OBJECTS = $(SOURCES:.cpp=.o)
TARGET = program

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) $(LDFLAGS) $(OBJECTS) -o $(TARGET)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET)

.PHONY: all clean
```

**Notes:**
- Use g++ for both compiling and linking
- C++17 is a good modern standard
- g++ automatically links C++ standard library

### 6.4 Case 4: Assembly with C Library Functions

**Project Structure:**
```
project/
├── main.asm        (calls printf, scanf, etc.)
├── util.asm
└── Makefile
```

**Build Commands:**
```bash
# Assemble
yasm -f elf64 -g dwarf2 main.asm -o main.o
yasm -f elf64 -g dwarf2 util.asm -o util.o

# Link with gcc (to get C runtime)
gcc -m64 -no-pie main.o util.o -o program
```

**Makefile Pattern:**
```makefile
AS = yasm
ASFLAGS = -f elf64 -g dwarf2
CC = gcc
LDFLAGS = -m64 -no-pie

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

**Notes:**
- Use gcc to link (not ld) to get C runtime
- `-no-pie` often needed for assembly programs
- Entry point is `main` (not `_start`)
- Must declare C functions as `extern` in assembly

### 6.5 Case 5: Hybrid C and Assembly

**Project Structure:**
```
project/
├── main.c
├── util.c
├── asm_math.asm    (functions called from C)
├── util.h
└── Makefile
```

**Build Commands:**
```bash
# Compile C files
gcc -c -Wall -g -std=c11 main.c -o main.o
gcc -c -Wall -g -std=c11 util.c -o util.o

# Assemble
yasm -f elf64 -g dwarf2 asm_math.asm -o asm_math.o

# Link with gcc
gcc -m64 main.o util.o asm_math.o -o program
```

**Makefile Pattern:**
```makefile
CC = gcc
CFLAGS = -Wall -Wextra -g -std=c11
AS = yasm
ASFLAGS = -f elf64 -g dwarf2
LDFLAGS = -m64

C_SOURCES = main.c util.c
ASM_SOURCES = asm_math.asm
C_OBJECTS = $(C_SOURCES:.c=.o)
ASM_OBJECTS = $(ASM_SOURCES:.asm=.o)
OBJECTS = $(C_OBJECTS) $(ASM_OBJECTS)
TARGET = program

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET)

.PHONY: all clean
```

**Notes:**
- Assembly functions must follow C calling convention
- Use `global` in assembly to export functions
- Use `extern` in C to declare assembly functions
- gcc handles linking both types of object files

**Example Assembly Function for C:**
```asm
section .text
global add_numbers    ; Export for C

add_numbers:
    ; Arguments: rdi = first number, rsi = second number
    ; Return in rax
    mov rax, rdi
    add rax, rsi
    ret
```

**Calling from C:**
```c
extern long add_numbers(long a, long b);

int main() {
    long result = add_numbers(5, 3);
    printf("Result: %ld\n", result);
    return 0;
}
```

### 6.6 Case 6: Hybrid C++ and Assembly

**Project Structure:**
```
project/
├── main.cpp
├── util.cpp
├── asm_math.asm
├── util.hpp
└── Makefile
```

**Build Commands:**
```bash
# Compile C++ files
g++ -c -Wall -g -std=c++17 main.cpp -o main.o
g++ -c -Wall -g -std=c++17 util.cpp -o util.o

# Assemble
yasm -f elf64 -g dwarf2 asm_math.asm -o asm_math.o

# Link with g++
g++ -m64 main.o util.o asm_math.o -o program
```

**Makefile Pattern:**
```makefile
CXX = g++
CXXFLAGS = -Wall -Wextra -g -std=c++17
AS = yasm
ASFLAGS = -f elf64 -g dwarf2
LDFLAGS = -m64

CXX_SOURCES = main.cpp util.cpp
ASM_SOURCES = asm_math.asm
CXX_OBJECTS = $(CXX_SOURCES:.cpp=.o)
ASM_OBJECTS = $(ASM_SOURCES:.asm=.o)
OBJECTS = $(CXX_OBJECTS) $(ASM_OBJECTS)
TARGET = program

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) $(LDFLAGS) $(OBJECTS) -o $(TARGET)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET)

.PHONY: all clean
```

**Notes:**
- Use g++ to link (not gcc) to get C++ runtime
- Assembly functions must be declared with `extern "C"` in C++
- This prevents C++ name mangling for assembly functions

**Example Assembly Function for C++:**
```asm
section .text
global add_numbers    ; Export for C++

add_numbers:
    mov rax, rdi
    add rax, rsi
    ret
```

**Calling from C++:**
```cpp
extern "C" long add_numbers(long a, long b);

int main() {
    long result = add_numbers(5, 3);
    std::cout << "Result: " << result << std::endl;
    return 0;
}
```

### 6.7 Case 7: Hybrid C, C++, and Assembly

**Project Structure:**
```
project/
├── main.cpp
├── c_util.c
├── cpp_util.cpp
├── asm_math.asm
├── c_util.h
├── cpp_util.hpp
└── Makefile
```

**Build Commands:**
```bash
# Compile C files
gcc -c -Wall -g -std=c11 c_util.c -o c_util.o

# Compile C++ files
g++ -c -Wall -g -std=c++17 main.cpp -o main.o
g++ -c -Wall -g -std=c++17 cpp_util.cpp -o cpp_util.o

# Assemble
yasm -f elf64 -g dwarf2 asm_math.asm -o asm_math.o

# Link with g++ (because we have C++ code)
g++ -m64 main.o c_util.o cpp_util.o asm_math.o -o program
```

**Makefile Pattern:**
```makefile
CC = gcc
CXX = g++
CFLAGS = -Wall -Wextra -g -std=c11
CXXFLAGS = -Wall -Wextra -g -std=c++17
AS = yasm
ASFLAGS = -f elf64 -g dwarf2
LDFLAGS = -m64

C_SOURCES = c_util.c
CXX_SOURCES = main.cpp cpp_util.cpp
ASM_SOURCES = asm_math.asm

C_OBJECTS = $(C_SOURCES:.c=.o)
CXX_OBJECTS = $(CXX_SOURCES:.cpp=.o)
ASM_OBJECTS = $(ASM_SOURCES:.asm=.o)
OBJECTS = $(C_OBJECTS) $(CXX_OBJECTS) $(ASM_OBJECTS)

TARGET = program

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) $(LDFLAGS) $(OBJECTS) -o $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET)

.PHONY: all clean
```

**Notes:**
- Use g++ to link (must use C++ linker when any C++ is present)
- C functions called from C++ need `extern "C"` in the C++ code
- Assembly functions need `extern "C"` in C++ code
- C functions don't need special treatment when calling assembly

**Interface Examples:**

**C function (c_util.c):**
```c
int c_function(int x) {
    return x * 2;
}
```

**Using C function from C++ (main.cpp):**
```cpp
extern "C" int c_function(int x);

int main() {
    int result = c_function(5);
    return 0;
}
```

**Assembly function:**
```asm
section .text
global asm_function

asm_function:
    mov rax, rdi
    add rax, rsi
    ret
```

**Using assembly from C++:**
```cpp
extern "C" long asm_function(long a, long b);

int main() {
    long result = asm_function(5, 3);
    return 0;
}
```

---

## 7. Dependency Management in Makefiles

### 7.1 Why Dependencies Matter

Make rebuilds files based on timestamps. A file is rebuilt if:
1. It doesn't exist, OR
2. Any of its dependencies are newer than it

**Example:**
```
program depends on main.o and util.o
main.o depends on main.c and util.h
util.o depends on util.c and util.h
```

If you change `util.h`, make should rebuild both `main.o` and `util.o`, then relink `program`.

### 7.2 Basic Dependency Rules

**Pattern:**
```makefile
target: dependency1 dependency2
	command to build target
```

**Example:**
```makefile
program: main.o util.o
	gcc main.o util.o -o program

main.o: main.c util.h
	gcc -c main.c -o main.o

util.o: util.c util.h
	gcc -c util.c -o util.o
```

### 7.3 Automatic Variables

Make provides special variables to simplify rules:

| Variable | Meaning | Example |
|----------|---------|---------|
| `$@` | Target name | In `program:` rule, `$@` = `program` |
| `$<` | First prerequisite | In `%.o: %.c` rule, `$<` = the .c file |
| `$^` | All prerequisites | All dependencies space-separated |
| `$?` | Prerequisites newer than target | Only changed files |

**Using automatic variables:**
```makefile
program: main.o util.o
	gcc $^ -o $@
	# Same as: gcc main.o util.o -o program

%.o: %.c
	gcc -c $< -o $@
	# Same as: gcc -c main.c -o main.o (for main.o)
```

### 7.4 Pattern Rules

Pattern rules use `%` as a wildcard:

```makefile
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
```

This means: "Any .o file depends on a .c file with the same basename."

**For assembly:**
```makefile
%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@
```

### 7.5 Header Dependencies (The Problem)

**The Challenge:** Object files depend on ALL headers they include, not just the source file.

If `main.c` includes `util.h` and `common.h`, then:
```makefile
main.o: main.c util.h common.h
	gcc -c main.c -o main.o
```

**But manually tracking this is error-prone!**

### 7.6 Automatic Dependency Generation

GCC can generate dependency files for you:

```bash
gcc -MM main.c
# Output: main.o: main.c util.h common.h
```

**Better: Generate .d files during compilation:**

```makefile
CC = gcc
CFLAGS = -Wall -g
DEPFLAGS = -MMD -MP

%.o: %.c
	$(CC) $(CFLAGS) $(DEPFLAGS) -c $< -o $@

# Include all .d files (if they exist)
-include $(OBJECTS:.o=.d)
```

**What this does:**
- `-MMD`: Generate dependency file (.d) during compilation
- `-MP`: Add phony targets for headers (avoids errors if header is deleted)
- `-include`: Include the .d files into the makefile

The `.d` files look like:
```makefile
main.o: main.c util.h common.h

util.h:
common.h:
```

### 7.7 Complete Makefile with Auto Dependencies

```makefile
CC = gcc
CFLAGS = -Wall -Wextra -g -std=c11
DEPFLAGS = -MMD -MP
LDFLAGS = -m64

SOURCES = main.c util.c helper.c
OBJECTS = $(SOURCES:.c=.o)
DEPENDS = $(OBJECTS:.o=.d)
TARGET = program

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(LDFLAGS) $^ -o $@

%.o: %.c
	$(CC) $(CFLAGS) $(DEPFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS) $(DEPENDS) $(TARGET)

-include $(DEPENDS)

.PHONY: all clean
```

### 7.8 Common Makefile Variables

**Standard Variables:**
```makefile
CC       = gcc          # C compiler
CXX      = g++          # C++ compiler
AS       = yasm         # Assembler
LD       = ld           # Linker (rarely used directly)
AR       = ar           # Archive tool (for static libraries)
RM       = rm -f        # Remove command

CFLAGS   = ...          # C compiler flags
CXXFLAGS = ...          # C++ compiler flags
ASFLAGS  = ...          # Assembler flags
LDFLAGS  = ...          # Linker flags
LDLIBS   = -lm -lpthread # Libraries to link
```

### 7.9 Phony Targets

Targets that don't represent files:

```makefile
.PHONY: all clean install test

all: $(TARGET)

clean:
	$(RM) $(OBJECTS) $(TARGET)

install: $(TARGET)
	cp $(TARGET) /usr/local/bin/

test: $(TARGET)
	./$(TARGET) --test
```

`.PHONY` tells make these targets should always run, even if a file named "clean" exists.

### 7.10 Directory Management

**Creating build directories:**
```makefile
BUILD_DIR = build
OBJECTS = $(BUILD_DIR)/main.o $(BUILD_DIR)/util.o

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@
```

The `|` separates normal dependencies from "order-only" dependencies. `$(BUILD_DIR)` must exist before building objects, but its timestamp doesn't matter.

### 7.11 Useful Makefile Functions

```makefile
# Get list of all C files in directory
SOURCES = $(wildcard *.c)

# Transform list
OBJECTS = $(patsubst %.c,%.o,$(SOURCES))
# Or: OBJECTS = $(SOURCES:.c=.o)

# Get basename
NAME = $(basename main.c)  # Returns: main

# Add prefix/suffix
OBJS = $(addprefix build/,$(OBJECTS))
```

### 7.12 Debugging Makefiles

**Print variable values:**
```makefile
$(info SOURCES = $(SOURCES))
$(info OBJECTS = $(OBJECTS))
```

**Run make with debugging:**
```bash
make -n        # Show commands without executing
make -d        # Show all debug info
make -p        # Print database of rules
```

---

## Summary and Quick Reference

### Quick Decision Guide

**Choosing your assembler:**
- **YASM**: Better NASM compatibility, good for learning
- **NASM**: Original, widely used, slightly different syntax
- Either works for basic programs

**Choosing your compiler/linker:**
- **Pure assembly (no libs)**: yasm + ld
- **Assembly + C libraries**: yasm + gcc
- **C program**: gcc
- **C++ program**: g++
- **C + Assembly**: gcc
- **C++ + Assembly**: g++
- **C + C++ + Assembly**: g++

**Key principle:** Use the linker that matches your "highest level" language:
- Have C++? → Use g++
- No C++, but have C? → Use gcc
- Pure assembly only? → Can use ld

### Essential Flag Cheat Sheet

**Compilation:**
```bash
-c                  # Compile only (don't link)
-o file             # Output filename
-Wall -Wextra       # All warnings
-g                  # Debug symbols
-O2                 # Optimization (release)
-std=c11            # C standard
-std=c++17          # C++ standard
-I path/            # Include path
-D MACRO            # Define macro
```

**Assembly:**
```bash
-f elf64            # 64-bit ELF format
-g dwarf2           # Debug format
-o file             # Output filename
```

**Linking:**
```bash
-o file             # Output filename
-L path/            # Library search path
-l name             # Link library
-m64                # 64-bit
-static             # Static linking
-shared             # Create shared library
-fPIC               # For shared libraries
-Wl,-rpath,path     # Runtime library path
```

### Typical Build Commands

**C program:**
```bash
gcc -Wall -g -std=c11 -c main.c -o main.o
gcc -Wall -g -std=c11 -c util.c -o util.o
gcc -m64 main.o util.o -o program
```

**C++ program:**
```bash
g++ -Wall -g -std=c++17 -c main.cpp -o main.o
g++ -Wall -g -std=c++17 -c util.cpp -o util.o
g++ -m64 main.o util.o -o program
```

**Assembly + C libraries:**
```bash
yasm -f elf64 -g dwarf2 main.asm -o main.o
yasm -f elf64 -g dwarf2 util.asm -o util.o
gcc -m64 -no-pie main.o util.o -o program
```

**Mixed C and Assembly:**
```bash
gcc -Wall -g -c main.c -o main.o
yasm -f elf64 -g dwarf2 util.asm -o util.o
gcc -m64 main.o util.o -o program
```

---

## Additional Resources

**Official Documentation:**
- GCC Manual: https://gcc.gnu.org/onlinedocs/
- GNU Make Manual: https://www.gnu.org/software/make/manual/
- YASM User Manual: http://yasm.tortall.net/Guide.html
- NASM Documentation: https://www.nasm.us/docs.php

**System ABI (Calling Conventions):**
- System V AMD64 ABI: https://refspecs.linuxbase.org/elf/x86_64-abi-0.99.pdf

**Useful Commands:**
```bash
man gcc          # GCC manual pages
man ld           # Linker manual
man as           # GNU assembler manual
gcc --help       # Quick help
objdump -d file  # Disassemble object file
nm file          # List symbols in object file
ldd program      # Show shared library dependencies
```

---

*This reference guide covers the essential knowledge for building makefiles across a variety of project types. Start with the simple cases and work up to the more complex hybrid scenarios.*