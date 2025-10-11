
test:
	@echo "Hello"

other_test:
	@echo "Hello, again"

build: main
.PHONY: build

main:
	ld -g dwarf2 -m64 -Werror -no-pie -z noexecstack -o main main.o

main.o: main.asm
	yasm -Werror -f elf64 -m amd64 -g dwarf2 -l main.list -o main.o main.asm
