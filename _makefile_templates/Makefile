# Derived from makefile demo by Michael Peralta

define speak
	$(info [Basic Makefile] $1)
endef

$(call speak, Runnig makefile...)

# ------------------
# Variables
# ------------------

# Compilers
CC	:=	gcc
CPP	:= 	g++
ASM	:=	yasm

# Compiler Flags
CC_FLAGS			:=	-Wall	-pedantic	-g
CPP_FLAGS			:=	$(CC_FLAGS) -std=c++23
ASM_FLAGS			:= -f	elf64	-gdwarf2

# Linker Flags
LINK_FLAGS		:=	$(CPP_FLAGS) -m64	-no-pie	-z noexecstack


# Tack on -c (compile only, creating object files,  no linking)
CC_FLAGS			:=	$(CC_FLAGS) -c
CPP_FLAGS			:=	$(CPP_FLAGS) -c


# Paths
BUILD_DIR_NAME	:=	_build
BUILD_DIR				:=	./$(BUILD_DIR_NAME)
BIN_NAME				:= 	main
BIN							:=	$(BUILD_DIR)/$(BIN_NAME)

# Print out variables
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

#
default:	help
.PHONY: default


#
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


# ------------------
# Link the object files into an executable
# ------------------	

# Build the first object file
$(BIN): cpp.o	c.o	asm.o 
	$(CPP)	$(LINK_FLAGS)	$(BUILD_DIR)/*.o	-o "$@"


# ------------------
# Build the object files
# ------------------

# Build sample object file from .cpp code file
$(BUILD_DIR)/cpp.o:		file.cpp 		| 	$(BUILD_DIR_NAME)
	$(CPP) $(CPP_FLAGS) file.cpp -o	cpp.o


# Build sample object file from .c code file
$(BUILD_DIR)/c.o:		file.c 		| 	$(BUILD_DIR_NAME)
	$(CC) $(CC_FLAGS) file.c -o	c.o

# Build sample object file from .asm code file
$(BUILD_DIR)/asm.o:		file.asm		| 	$(BUILD_DIR_NAME)
	$(ASM) $(ASM_FLAGS) file.asm -o	asm.o	










