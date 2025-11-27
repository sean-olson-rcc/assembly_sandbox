;------------------------------------------------------------------------------
; title: main.asm
; description: this is a simple assembly-language that uses the C-Library function
; by: sean olson
; date: 11/27/25
;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
; data section for initialized variables
;------------------------------------------------------------------------------

section     .data

SYS_WRITE       equ     1
SYS_EXIT        equ     60

EXIT_SUCCESS    equ     0

FD_STDIN        equ     0 ; define the standard input
FD_STDOUT       equ     1 ; define the standard output
FD_STDERR       equ     2 ; define the standard error

; db is a byte type variable that is held in memory. 
; it's a pointer, pointing to the first character in the string
HELLO_STRING    db     "Hello, my name is Sean Olson.",13,10,"This is an assembly-language program that uses the C-Library.",13,10,0

;------------------------------------------------------------------------------
; bss section for unitialized global and static variables
;------------------------------------------------------------------------------
section     .bss

;------------------------------------------------------------------------------
; text section for program instructions
;------------------------------------------------------------------------------
section     .text

extern printf

; entry point to our program.  because it uses c-library functions, the entry point meust be called main
global main
main:

		;----------------------
    ; put the stack in 16-byte alignment
		sub rsp, 16
		and rsp, -16

		;----------------------
    ; print a hello message
    mov rdi, HELLO_STRING
    call printf
    
		;----------------------
    ; Setup the return value and call the exit syscall
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall
