define say
	$(info [Multi-FIle Program Sample] $1)
endef

#
CPP := g++
CC := gcc
ASM := yasm
CPP_FLAGS := -c
C_FLAGS := -c -Wall -gdwarf-2 -m64 -no-pie
YASM_FLAGS := -f elf64 -g dwarf2 -Werror
LINK_FLAGS := -Wall -gdwarf-2 -m64 -Werror -z noexecstack

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
	@echo "***** Compute the Area of a Circle *****"
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
$(BIN):	main.o manager.o display_array.o assembly_utilities.o reverse.o
	$(CPP) $(LINK_FLAGS) *.o  *.so -o $(BIN)

#
main.o:	main.c
	$(CC) $(C_FLAGS) $< -o "$@"

#
reverse.o:	reverse.cpp
	$(CPP) $(CPP_FLAGS) $< -o "$@"	

#
manager.o:	manager.asm
	$(ASM) $(YASM_FLAGS) $< -o "$@"

#
display_array.o:	display_array.asm
	$(ASM) $(YASM_FLAGS) $< -o "$@" 

#
assembly_utilities.o:	assembly_utilities.asm
	$(ASM) $(YASM_FLAGS) $< -o "$@" 	




