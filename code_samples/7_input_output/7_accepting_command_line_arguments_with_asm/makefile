# Derived from makefile demo by Michael Peralta

define speak
	$(info [Command-Line Arguments with ASM] $1)
endef

# assembler flags
ASM 				:=	yasm
ASM_FLAGS 	:= 	-f elf64	-gdwarf2 -Werror	

#	linker flags
# Using GCC libraries make reading in CLI args easier
LINKER				:=	ld
LINKER_FLAGS	:=	-g --fatal-warnings

#	executable name
BIN_NAME			:=	main
BIN 					:= ./$(BIN_NAME)

#	file containing gdb commands
GDB_FILE			:=	gdb.txt

# default target pointing to help
default:	help
.PHONY: default

# help menu
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


# build target: initiates the compilation and linking processes only
build:	$(BIN)
.PHONY: build

# run target, dependent on build process being completed
run:	build
	$(call speak, Running the program!)
	$(BIN) firstArg	secondArg	thirdArg	fourthArg
.PHONY: run

# run the program in the debugger, dependant on the build process being completed
debug:	build
	$(call speak, Debugging the program)
	gdb $(BIN) --command $(GDB_FILE) --args $(BIN) firstArg	secondArg	thirdArg	fourthArg
.PHONY: debug

# delete the object files and the program file
clean:
	-rm *.o
	-rm $(BIN)
.PHONY: clean

# build the main executable (binary)
$(BIN):	main.o
	$(call speak, Linking the executabe: $@)
	$(LINKER) $(LINKER_FLAGS) *.o -o $(BIN)

# compile the pure-assembly module
main.o:	main.asm
	$(call speak, Assembling $@)
	$(ASM) $(ASM_FLAGS) $< -o "$@"	

	







