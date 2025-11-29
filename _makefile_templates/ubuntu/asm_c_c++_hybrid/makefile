# ------------------------------------------------------------
# about: a makefile template for a hybrid assembly, C, and C++ program 
# source: derived from makefile developed and demonstrated by Professor Michael Peralta
# date:	11/27/2025
# by: Sean Olson
# ------------------------------------------------------------

# print a blank line to create some separation
$(info )

define output
	$(info [Assembly, C, and C++ Hybrid Makefile] $1)
	$(info )
endef

# print the root path
ROOT_PATH := $(abspath .)
$(call output, ROOT_PATH: $(ROOT_PATH))

# compilers
CC := gcc
CXX := g++
ASM := yasm

# compilation flags
CFLAGS := -Wall -Werror -Wextra -m64 -g -std=c11
CXXFLAGS := -Wall -Werror -Wextra -m64 -g -std=c++17
DEPFLAGS := -MMD -MP
ASMFLAGS := -f elf64 -g dwarf2

# production-environment link flags
PROD_LDFLAGS := -m64 -Wl,-z,noexecstack

# dev-environment link flags disable position-independent execution for development
DEV_LDFLAGS := $(PROD_LDFLAGS) -no-pie

# name and path for the final executable
BIN_NAME := main
BIN := ./$(BIN_NAME)

# source files
C_SOURCES := main.c
CXX_SOURCES := input.cpp
ASM_SOURCES := manager.asm
C_OBJECTS := $(C_SOURCES:.c=.o)
CXX_OBJECTS := $(CXX_SOURCES:.cpp=.o)
ASM_OBJECTS := $(ASM_SOURCES:.asm=.o)
OBJECTS := $(C_OBJECTS) $(CXX_OBJECTS) $(ASM_OBJECTS)
DEPENDS := $(C_OBJECTS:.o=.d) $(CXX_OBJECTS:.o=.d)

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
build_prod: LDFLAGS := $(PROD_LDFLAGS)
build_prod: $(BIN)
.PHONY: build_prod

# phony target that builds the development version
build: LDFLAGS := $(DEV_LDFLAGS)
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
	-rm -f $(OBJECTS) $(DEPENDS) $(BIN)
.PHONY: clean

# link the object files into final executable (use g++ because we have C++ code)
$(BIN): $(OBJECTS)
	$(CXX) $(LDFLAGS) $^ -o $@

# compile C source files, creating object files
%.o: %.c
	$(CC) $(CFLAGS) $(DEPFLAGS) -c $< -o $@

# compile C++ source files, creating object files
%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(DEPFLAGS) -c $< -o $@

# assemble assembly source files, creating object files
%.o: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@

# include dependency files
-include $(DEPENDS)