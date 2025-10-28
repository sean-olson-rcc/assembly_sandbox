define speak
	$(info [Local Variable Sample] $1)
endef

$(call speak, Running makefile...)

#----------
# Variables
#----------

# Compilers
CC					:=	gcc
CPP					:=	g++
ASM					:= yasm

# Compiler flags
CC_FLAGS		:=	-Wall -pedantic -g
CPP_FLAGS		:=	$(CC_FLAGS) -std=c++23
ASM_FLAGS		:=	-f elf64 -gdwarf2

# Linker Flags
LINK_FLAGS	:=	$(CPP_FLAGS) -m64 -no-pie -z nonexecstack

# Tack on -c (compile only, creating object files,  no linking)
CC_FLAGS			:=	$(CC_FLAGS) -c
CPP_FLAGS			:=	$(CPP_FLAGS) -c

# Paths
BUILD_DIR_NAME	:=	_build
BUILD_DIR 			:=	./$(BUILD_DIR_NAME)
BIN_NAME				:=	main
BIN 						:=	$(BIN_NAME)

default:	help
.PHONY: default

# Print out variables
config:
	$(call	speak, CC == $(CC))
	$(call	speak, CPP == $(CPP))
	$(call	speak, ASM == $(ASM))
	$(call	speak, CC_FLAGS == $(CC_FLAGS))
	$(call	speak, CPP_FLAGS == $(CPP_FLAGS))
	$(call	speak, LINK_FLAGS == $(LINK_FLAGS))
	$(call	speak, ASM_FLAGS == $(ASM_FLAGS))
	$(call	speak, BUILD_DIR_NAME == $(BUILD_DIR_NAME))
	$(call	speak, BUILD_DIR == $(BUILD_DIR))
	$(call	speak, BIN_NAME == $(BIN_NAME))
	$(call	speak, BIN == $(BIN))
.PHONY: config

# Print out a help menu
help:
	@echo "***** Makefile Options *****"
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

# Ensure the build directory exists
$(BUILD_DIR):
	$($call speak, Ensuring build dir: $@)


# Run the program
run: build 
	$(BIN) 
.PHONY: run 


# Build and link the object files
build: $(BIN)


debug:	build
	gdb $(BIN_NAME) -x gdb-commands.txt
.PHONY: debug

#
clean:
	-rm *.o
	-rm $(BIN)
.PHONY: clean


# ------------------
# Link the object files into an executable
# ------------------	

# Build the first object file
$(BIN): driver.o	local.o 
	$(CPP)	$(LINK_FLAGS)	*.o	-o "$@"


# ------------------
# Build the object files
# ------------------

# Build sample object file from .cpp code file
driver.o:		driver.cpp
	$(CPP) $(CPP_FLAGS) driver.cpp -o	driver.o


# Build sample object file from .asm code file
local.o:		local.asm
	$(ASM) $(ASM_FLAGS) local.asm -o	local.o	
