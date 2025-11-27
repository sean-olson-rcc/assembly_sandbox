# ------------------------------------------------------------
# about: a makefile template for a pure C-language program 
# source: derived from makefile developed and demonstrated by Professor Michael Peralta
# date:	11/27/2025
# by: Sean Olson
# ------------------------------------------------------------

#print a blank line to create some seperation
$(info )

define output
	$(info [C-Language Makefile] $1)
	$(info )
endef

# print the root path
ROOT_PATH := $(abspath .)
$(call output, ROOT_PATH: $(ROOT_PATH))

# compilers and linker
CC	:= gcc
LINKER := gcc

# compilation and linking flags (the -lc flag tells the linker to link against the C Standard Library)
CC_FLAGS := -Wall -Werror -m64 -gdwarf-2 -c

# production-environment link flags
PROD_LINK_FLAGS := -Wall -Werror -m64 -gdwarf-2 -z noexecstack

# dev-environment link flags disable position-independent execution for development
DEV_LINK_FLAGS := $(PROD_LINK_FLAGS) -no-pie

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
	@echo "1. make help          ==> This menu"
	@echo "2. make build         ==> Build the dev-environment program"	
	@echo "3. make build_prod    ==> Build the production-version program"
	@echo "4. make run           ==> Run the dev-env program"	
	@echo "5. make debug         ==> Debug the program"
	@echo "6. make clean         ==> Clean the build area"
	@echo
.PHONY: help

# phony target that launches the build process for the production version of the program
build_prod:	
	$(MAKE) $(BIN) LINK_FLAGS="$(PROD_LINK_FLAGS)"
.PHONY: build_prod

# phony target that launches the build process for the development version of the program
build:
	$(MAKE) $(BIN) LINK_FLAGS="$(DEV_LINK_FLAGS)"
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
main.o:	main.c
	$(CC) $(CC_FLAGS) $< -o $@



