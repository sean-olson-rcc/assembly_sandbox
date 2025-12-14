;------------------------------------------------------------------------------
; title: 7.1 Assembly System Services Demo
; description: demo the system services in a yasm x86 ubuntu assembly program
; by: sean olson
; date: 12/14/2025
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; data section for initialized variables
;------------------------------------------------------------------------------
section					.data

;--------------------
; c-strings
MSG_HELLO												db							"Hello, my name is Sean Olson, and I'm printing using a system service.",13,10
MSG_HELLO_LEN										equ							$-MSG_HELLO

;--------------------
; system calls
SYS_READ												equ							0
SYS_WRITE												equ							1
SYS_OPEN												equ							2
SYS_CREATE											equ							85
SYS_CLOSE												equ							3
SYS_EXIT												equ							60

;--------------------
; file descriptors
FD_STDIN												equ							0
FD_STDOUT												equ							1
FD_STDERROR											equ							2

;--------------------
; exit codes
EXIT_SUCCESS										equ							0
EXIT_FAIL												equ							1

;------------------------------------------------------------------------------
;  uninitialized-variable
;------------------------------------------------------------------------------
section					.bss


;------------------------------------------------------------------------------
;  text section
;------------------------------------------------------------------------------
section .text

global _start


_start:

		mov rax, SYS_WRITE
		mov rdi, FD_STDOUT
		mov	rsi, MSG_HELLO
		mov	rdx, MSG_HELLO_LEN
		syscall

		mov rax,	SYS_EXIT
		mov	rdi,	EXIT_SUCCESS
		syscall