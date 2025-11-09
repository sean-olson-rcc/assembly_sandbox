;------------------------------------------------------------
; name: cli_args.asm
; attribution: copied from code-review with RCC Professor Michael Peralta
; date: 11/3/2025
;------------------------------------------------------------

; Begin data section
section     .data

SYS_WRITE       equ     1
SYS_EXIT        equ     60

EXIT_SUCCESS    equ     0

FD_STDIN        equ     0 ; define the standard input
FD_STDOUT       equ     1 ; define the standard output
FD_STDERR       equ     2 ; define the standard error

; db is a byte type variable that is held in memory. 
; It's a pointer, pointing to the first character in the string
HELLO_STRING    db     "Hello, my name is Sean Olson", 13, 10

; the $- preceeding the name of another symbol, and it counts the characters
HELLO_STRING_LEN    equ   $-HELLO_STRING  

; Begin uninitialized data section
section     .bss


; Begin text section
section     .text

; Entry point to our program
global _start
_start:

    ; Print a hello message
    mov rax, SYS_WRITE
    mov rdi, FD_STDOUT     ;parameter directing where output goes
    mov rsi, HELLO_STRING  ;pointer to first character in string
    mov rdx, HELLO_STRING_LEN  ;instruction on how many characters are in string
    syscall
    

    ; Setup the return value and call the exit syscall
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall