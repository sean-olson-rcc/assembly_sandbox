define say
	$(info [Signed Integer Division] $1)
endef

#
REPO_PATH := $(abspath .)
$(call say,REPO_PATH: $(REPO_PATH))

# C++ compiler and flags
CPP := g++
CPP_FLAGS := -Wall -m64 -g dwarf-2 -std=c++17 -c

# C compiler and flags
CC := gcc
CC_FLAGS := -Wall -m64 -g dwarf-2

#
YASM_FLAGS := -f elf64 -g dwarf2
LINK_FLAGS := -g

LINKER := g++
LINKER_FLAGS := -Wall -m64 -g dwarf-2 -no-pie -z noexecstack

#
BIN_NAME := main
BIN := ./$(BIN_NAME)

#
default:	help
.PHONY: default

help:
	@echo "***** Makefile Menu *****"
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

#
build:	$(BIN)
.PHONY: build

#
run:	$(BIN)
	$(BIN)
.PHONY: run

#
debug:	build
	gdb $(BIN_NAME) -x gdb-commands.txt
.PHONY: debug

#
clean:
	-rm -f *.o
	-rm -f $(BIN)
.PHONY: clean

#
$(BIN):	main.o stats.o
	ld $(LINK_FLAGS) *.o -o $(BIN)

#
main.o:	main.asm 
	yasm $(YASM_FLAGS) main.asm -o main.o -l main.list





