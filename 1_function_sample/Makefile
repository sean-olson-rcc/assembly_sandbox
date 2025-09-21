# Define a custom function to print informational messages during build
define say
	$(info [Function Sample] $1)
endef

# Variables section - define key paths and settings

# Get the absolute path of the current directory (project root)
REPO_PATH := $(abspath .)
$(call say,REPO_PATH: $(REPO_PATH))

# Platform selection - can be overridden with: make PLATFORM=MAC build
# Default to LINUX if not specified
PLATFORM ?= LINUX

# Platform-specific configuration
ifeq ($(PLATFORM),LINUX)
    # Linux: ELF64 object format, GNU ld linker
    YASM_FORMAT := elf64
    DEBUG_FORMAT := dwarf2
    LINKER := ld
    LINK_FLAGS := -g
    BIN_SUFFIX :=
endif

ifeq ($(PLATFORM),MAC)
    # macOS: Mach-O 64-bit object format, ld linker with different flags
    YASM_FORMAT := macho64
    DEBUG_FORMAT := null
    LINKER := ld
    LINK_FLAGS := -macosx_version_min 10.7 -lSystem -arch x86_64
    BIN_SUFFIX :=
endif

ifeq ($(PLATFORM),WIN)
    # Windows: PE32+ object format, link.exe or mingw linker
    YASM_FORMAT := win64
    DEBUG_FORMAT := cv8
    LINKER := x86_64-w64-mingw32-ld
    LINK_FLAGS := -g
    BIN_SUFFIX := .exe
endif

# YASM assembler flags:
# -f FORMAT     = Generate object format for target platform
# -Werror       = Treat warnings as errors (strict compilation)
# -g FORMAT     = Include debugging information (format varies by platform)
YASM_FLAGS := -f $(YASM_FORMAT) -Werror -g $(DEBUG_FORMAT)

# Define the base name for source file and executable (can be overridden)
# Usage: make PROGRAM=myprogram build
PROGRAM ?= function

# Define the name of our final executable program (with platform suffix)
BIN_NAME := $(PROGRAM)$(BIN_SUFFIX)
# Create full path to the binary (in current directory)
BIN := ./$(BIN_NAME)

# Source file paths
ASM_FILE := $(PROGRAM).asm
OBJ_FILE := $(PROGRAM).o

# Default target - when you just type 'make', it runs the help target
default:	help
.PHONY: default


# Help target - displays available make commands
help:
	@echo "***** Makefile Menu *****"
	@echo
	@echo "make help          ==> This menu"
	@echo
	@echo "make build         ==> Build the program (default: LINUX)"
	@echo "make run           ==> Run the program"
	@echo "make debug         ==> Debug the program"
	@echo
	@echo "make clean         ==> Clean the build area"
	@echo
	@echo "Platform targets:"
	@echo "make PLATFORM=LINUX build   ==> Build for Linux x86_64"
	@echo "make PLATFORM=MAC build     ==> Build for macOS x86_64"
	@echo "make PLATFORM=WIN build     ==> Build for Windows x86_64"
	@echo
	@echo "Custom program name:"
	@echo "make PROGRAM=myfile build    ==> Build myfile.asm -> myfile"
	@echo
.PHONY: help

# Build target - compiles and links the program
# Depends on $(BIN) which triggers the compilation process
build:	$(BIN)
.PHONY: build

# Run target - executes the compiled program
# First ensures the program is built, then runs it
run:	$(BIN)
	$(BIN)
.PHONY: run

# Debug target - launches the program in GDB debugger
# Uses gdb-commands.txt file for automated debugger setup
debug:	build
	gdb $(BIN_NAME) -x gdb-commands.txt
.PHONY: debug

# Clean target - removes all compiled files
# The '-' prefix ignores errors if files don't exist
clean:
	-rm *.o
	-rm $(BIN)
.PHONY: clean

# Main executable rule - links object files into final program
# Uses platform-specific linker with appropriate flags
$(BIN):	$(OBJ_FILE)
	$(LINKER) --fatal-warnings $(LINK_FLAGS) $(OBJ_FILE) -o $(BIN)

# Object file rule - assembles source code into object file
# Uses YASM assembler to convert .asm file into .o file
$(OBJ_FILE):	$(ASM_FILE)
	yasm $(YASM_FLAGS) $(ASM_FILE) -o $(OBJ_FILE)




