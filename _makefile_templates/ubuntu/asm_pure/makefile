# ------------------------------------------------------------
# about: a makefile template for a pure assembly program 
# source: derived from makefile developed and demonstrated by Professor Michael Peralta
# date:	11/20/2025
# by: Sean Olson
# ------------------------------------------------------------

# print a blank line to create some separation
$(info )

define output
	$(info [Pure Assembly Makefile] $1)
	$(info )
endef

# print the root path
ROOT_PATH := $(abspath .)
$(call output, ROOT_PATH: $(ROOT_PATH))

# assembler and linker
ASM := yasm
LINKER := ld

# assembly flags
ASM_FLAGS := -f elf64 -g dwarf2

# production-environment link flags
PROD_LINK_FLAGS := -m elf_x86_64 -z noexecstack

# dev-environment link flags (same as production for pure ld)
DEV_LINK_FLAGS := $(PROD_LINK_FLAGS)

# name and path for the final executable
BIN_NAME := main
BIN := ./$(BIN_NAME)

# source files
ASM_SOURCES := main.asm
OBJECTS := $(ASM_SOURCES:.asm=.o)

# default operation: print the help menu
default: help
.PHONY: default

# the makefile help menu
help:
	@echo
	@echo "--------- Makefile Menu ----------"
	@echo
	@echo "1. make help          ==> This menu"
	@echo "2. make build         ==> Build the dev-environment program"	
	@echo "3. make build_prod    ==> Build the production-version program"
	@echo "4. make run           ==> Run the dev-env program"	
	@echo "5. make debug         ==> Debug the program"
	@echo "6. make clean         ==> Clean the build area"
	@echo
.PHONY: help

# phony target that builds the production version
build_prod: LINK_FLAGS := $(PROD_LINK_FLAGS)
build_prod: $(BIN)
.PHONY: build_prod

# phony target that builds the development version
build: LINK_FLAGS := $(DEV_LINK_FLAGS)
build: $(BIN)
.PHONY: build

# phony target that runs the executable
run: $(BIN)
	$(BIN)
.PHONY: run

# phony target that runs the executable in the GNU debugger
debug: build
	gdb $(BIN_NAME) -x gdb-commands.txt
.PHONY: debug

# phony target that deletes all products of compilation
clean:
	-rm -f *.lst
	-rm -f $(OBJECTS)
	-rm -f $(BIN)
.PHONY: clean

# link the object files into final executable
$(BIN): $(OBJECTS)
	$(LINKER) $(LINK_FLAGS) $^ -o $@

# assemble assembly code files, creating object files
%.o: %.asm
	$(ASM) $(ASM_FLAGS) $< -o $@