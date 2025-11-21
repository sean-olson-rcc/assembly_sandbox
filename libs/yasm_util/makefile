# ------------------------------------------------------------
# about: derived from makefile developed and demonstrated by Professor Michael Peralta
# date:	11/20/2025
# ------------------------------------------------------------


define speak
	$(info [YASM Utility Library] $1)
endef

# assembler and flags
ASM 			:= 	yasm
ASM_FLAGS := 	-f elf64 -g dwarf2

CC				:= gcc
LIB_FLAGS	:= -shared

# linker and flags
LINKER				:=	gcc
LINKER_FLAGS 	:= -Wall -m64	-gdwarf-2	-no-pie	-z noexecstack -lc

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

# link the main object file with the messanger shared-object file
$(BIN):	main.o yasm_util.o 
	$(LINKER) $(LINKER_FLAGS) yasm_util.so main.o -o $(BIN)

# create the shared object library
yasm_util.so: yasm_util.o
	$(CC) $(LIB_FLAGS) yasm_util.o -o yasm_util.so

# compile the main driver
main.o:	main.asm
	$(ASM) $(ASM_FLAGS) main.asm -o main.o	

# compile the yasm_util library code
yasm_util.o:	yasm_util.asm
	$(ASM) $(ASM_FLAGS) yasm_util.asm -o yasm_util.so		




