# ------------------------------------------------------------
# about: a makefile template for a pure assembly program 
# source: derived from makefile developed and demonstrated by Professor Michael Peralta
# date:	11/20/2025
# target: 
# ------------------------------------------------------------

#print a blank line to create some seperation
$(info )

define output
	$(info [Pure Assembly Makefile] $1)
	$(info )
endef

# print the root path
ROOT_PATH := $(abspath .)
$(call output, ROOT_PATH: $(ROOT_PATH))

# compiler and linker
ASM	:= yasm
LINKER := ld

# compilation and linking flags
ASM_FLAGS := -f elf64 -g dwarf2 -l main.lst
LINK_FLAGS := -g

# name and path for the final executable
BIN_NAME := main
BIN := ./$(BIN_NAME)

# default operation: print the help menu
default:	help
.PHONY: default

# the makefile help menu
help:
	@echo
	@echo "--------- Makefile Menu ----------"
	@echo
	@echo "make help          ==> This menu"
	@echo
	@echo "make build         ==> Build the program"
	@echo "make run           ==> Run the program"
	@echo "make debug         ==> Debug the program"
	@echo
	@echo "make clean         ==> Clean the build area"
	@echo
.PHONY: help

# phony target that launches the build process
build:	$(BIN)
.PHONY: build

# phony target that runs the exectable
run:	$(BIN)
	$(BIN)
.PHONY: run

# phony target that runs the executable in the GNU debugger
debug:	build
	gdb $(BIN_NAME) -x gdb-commands.txt
.PHONY: debug

# phony target that deletes all products of compilation
clean:
	-rm -f *.lst
	-rm -f *.o
	-rm -f $(BIN)
.PHONY: clean

# link the object files into final executable
$(BIN):	main.o
	$(LINKER) $(LINK_FLAGS) *.o -o $(BIN)

# compile the assembly code file, creating an object file
main.o:	main.asm
	$(ASM) $(ASM_FLAGS) main.asm -o main.o



