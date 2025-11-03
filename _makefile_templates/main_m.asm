; Begin data section
section     .data

; macOS uses BSD syscalls - add 0x2000000 to the syscall number
SYS_WRITE       equ     0x2000004  ; BSD write syscall
SYS_EXIT        equ     0x2000001  ; BSD exit syscall

EXIT_SUCCESS    equ     0

FD_STDIN        equ     0
FD_STDOUT       equ     1
FD_STDERR       equ     2

HELLO_STRING    db     "Hello, my name is Sean Olson", 13, 10
HELLO_STRING_LEN    equ   $-HELLO_STRING  

; Begin uninitialized data section
section     .bss

; Begin text section
section     .text

; Entry point for macOS
global _main
_main:

    ; Print a hello message
    mov rax, SYS_WRITE
    mov rdi, FD_STDOUT
    lea rsi, [rel HELLO_STRING]    ; RIP-relative addressing
    mov rdx, HELLO_STRING_LEN
    syscall
    
    ; Setup the return value and call the exit syscall
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall