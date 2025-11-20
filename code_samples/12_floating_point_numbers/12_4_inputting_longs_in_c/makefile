# ------------------------------------------------------------
# about: derived from makefile developed and demonstrated by Professor Michael Peralta
# date:	11/20/2025
# ------------------------------------------------------------

define speak
	$(info [Inputting Longs in C] $1)
endef

#
CC	:= gcc
CC_FLAGS			:=	-Wall -gdwarf-2 -c

#
CPP	:= g++
CPP_FLAGS			:=	-Wall -gdwarf-2 -m64 -no-pie -std=c++23 -c

ASM := yasm
YASM_FLAGS 		:= -f elf64 -g dwarf2 -Werror

LINKER				:= 	g++
LINKER_FLAGS 		:= -Wall -gdwarf-2 -m64 -no-pie -z noexecstack

#
REPO_PATH := $(abspath .)
$(call speak,REPO_PATH: $(REPO_PATH))

#
BIN_NAME := main
BIN := ./$(BIN_NAME)
$(call speak,Binary path: $(BIN))

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
$(BIN):	main.o
	$(LINKER) $(LINKER_FLAGS) *.o -o "$@"


#
main.o:	main.c
	$(CC) $(CC_FLAGS) $< -o "$@" 








