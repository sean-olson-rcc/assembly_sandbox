define say
	$(info [Messenger Library] $1)
endef

# assembler and flags
ASM 			:= 	yasm
ASM_FLAGS := 	-f elf64 -g dwarf2

# linker and flags
LINKER				:=	g++
LINKER_FLAGS 	:= -Wall -m64	-gdwarf-2	-no-pie	-z noexecstack

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
$(BIN):	main.o messenger.o 
	$(LINKER) $(LINKER_FLAGS) *.o -o $(BIN)

#
main.o:	main.asm
	$(ASM) $(ASM_FLAGS) $< -o "$@"	

#
messenger.o:	messenger.asm
	$(ASM) $(ASM_FLAGS) $< -o "$@"		




