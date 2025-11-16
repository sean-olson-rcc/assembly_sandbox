define speak
	$(info [Pointers] $1)
endef

#
CPP	:= g++
ASM := yasm

CPP_FLAGS			:=	-Wall -gdwarf-2 -m64 -no-pie -std=c++23 -c
YASM_FLAGS 		:= -f elf64 -g dwarf2 -Werror
LINK_FLAGS 		:= -Wall -gdwarf-2 -m64 -Werror -no-pie -z noexecstack

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
$(BIN):	driver.o point.o 
	$(CPP) $(LINK_FLAGS) *.o *.so -o $(BIN)


#
driver.o:	driver.cpp
	$(CPP) $(CPP_FLAGS) $< -o "$@" 

#
point.o:	point.asm
	$(ASM) $(YASM_FLAGS) $< -o "$@"






