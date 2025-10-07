# Assembly Programming Sandbox

A collection of x86-64 assembly language programs designed as a learning environment and code reference repository. This sandbox provides cross-platform build support for Linux, macOS, and Windows, along with educational examples and debugging tools for assembly programming practice.

## Table of Contents

| Directory/File | Description |
|---------------|-------------|
| [`_makefile_templates/`](./_makefile_templates/) | Platform-specific Makefile templates and build automation scripts |
| [`notes/`](./notes/) | Reference documentation and assembly programming guides |
| [`notes/register_usage.md`](./notes/register_usage.md) | Comprehensive x86-64 register reference and calling conventions |
| [`LICENSE`](./LICENSE) | Project license information |


## Makefile Templates

The `_makefile_templates/` directory contains platform-specific Makefile templates and a cross-platform build automation script for simplified project setup.

### Template Files

| File | Description |
|------|-------------|
| [`makefile_linux`](./_makefile_templates/makefile_linux) | Linux-specific Makefile using YASM with ELF64 format and GNU ld linker |
| [`makefile_mac`](./_makefile_templates/makefile_mac) | macOS-specific Makefile using YASM with Mach-O 64-bit format and clang linker |
| [`makefile_win64`](./_makefile_templates/makefile_win64) | Windows-specific Makefile using YASM with win64 format and Microsoft linker |
| [`mk.sh`](./_makefile_templates/mk.sh) | Cross-platform shell script that auto-detects OS and runs the appropriate Makefile |
| `main_l.asm` | Sample Linux assembly source file |
| `main_m.asm` | Sample macOS assembly source file |


### Available Make Targets

| Target | Description |
|--------|-------------|
| `make` or `make help` | Display help menu with all available commands |
| `make build` | Compile and link the program using current PLATFORM |
| `make run` | Build and execute the program |
| `make debug` | Launch the program in GDB debugger |
| `make clean` | Remove all compiled object files and executables |

### Using the Templates

The templates provide a standalone build system for individual assembly projects:

1. **Auto-detect platform** (recommended):
   ```bash
   ./mk.sh build
   ./mk.sh run
   ./mk.sh clean
   ```

2. **Manual platform selection**:
   ```bash
   # Linux
   make -f makefile_linux build

   # macOS
   make -f makefile_mac build

   # Windows (Git Bash/MSYS/Cygwin)
   make -f makefile_win64 build
   ```

### Template Features

Each platform-specific Makefile includes:
- **Standard targets**: `help`, `build`, `run`, `debug`, `clean`
- **Platform-optimized flags**: Appropriate YASM format flags and debug symbols
- **Correct linker**: `ld` (Linux), `clang` (macOS), `link` (Windows)
- **Binary naming**: Platform-specific output names (`main_l`, `main_m`, `main_w.exe`)

The `mk.sh` script automatically detects the operating system and invokes the correct Makefile, simplifying cross-platform development workflows.
