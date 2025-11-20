# ------------------------------------------------------------
# about: derived from makefile developed and demonstrated by Professor Michael Peralta
# date:	11/20/2025
# ------------------------------------------------------------

define say
	$(info [Math Sample] $1)
endef


#
ASM := yasm
YASM_FLAGS := -f elf64 -g dwarf2 -Werror
LINK_FLAGS := -Wall -gdwarf-2 -m64 -Werror -no-pie -z noexecstack

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
	@echo "***** Integer-Division Sample *****"
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
	ld -g *.o -o $(BIN)


#
main.o:	main.asm
	$(ASM) $(YASM_FLAGS) $< -o "$@"






