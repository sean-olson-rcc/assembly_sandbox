# ------------------------------------------------------------
# about: derived from makefile developed and demonstrated by Professor Michael Peralta
# date:	11/20/2025
# ------------------------------------------------------------

define say
	$(info [Find the Largest Number] $1)
endef


#
CPP	:= g++
ASM := yasm

CPP_FLAGS			:=	-Wall -gdwarf-2 -m64 -no-pie -std=c++23
YASM_FLAGS 		:= -f elf64 -g dwarf2 -Werror
LINK_FLAGS 		:= -Wall -gdwarf-2 -m64 -Werror -no-pie -z noexecstack

CPP_FLAGS			:=	$(CPP_FLAGS) -c

#
REPO_PATH := $(abspath .)
$(call say,REPO_PATH: $(REPO_PATH))

#
BIN_NAME := main
BIN := ./$(BIN_NAME)
$(call say,Binary path: $(BIN))

#
default:	help
.PHONY: default


#
help:
	@echo "***** Largest Number  *****"
	@echo
	@echo "make help         ==> This help menu"
	@echo
	@echo "make build        ==> Rebuild your project"
	@echo "make run          ==> Run your project"
	@echo "make debug        ==> Debug your project"
	@echo
	@echo "make clean        ==> Clean temporary build files"
	@echo
.PHONY: help


#
build:	$(BIN)
.PHONY: build


#
run:	build
	$(BIN)
.PHONY: run


#
debug:	build
	gdb $(BIN_NAME) -x gdb-commands.txt
.PHONY: debug


#
clean:
	-rm *.o
	-rm $(BIN)
.PHONY: clean


#
$(BIN):	largest.o input_array.o find_largest.o manager.o output_array.o
	$(CPP) $(LINK_FLAGS) *.o *.so -o $(BIN)


#
largest.o:	largest.cpp
	$(CPP) $(CPP_FLAGS) $< -o "$@" 

#
input_array.o:	input_array.cpp
	$(CPP) $(CPP_FLAGS) $< -o "$@"	


#
find_largest.o:	find_largest.asm
	$(ASM) $(YASM_FLAGS) $< -o "$@"

#
manager.o:	manager.asm
	$(ASM) $(YASM_FLAGS) $< -o "$@"	

#
output_array.o:	output_array.asm
	$(ASM) $(YASM_FLAGS) $< -o "$@"	




