;------------------------------------------------------------------------------
; title: manager.asm
; description: this is a simple assembly-language program used to demonstrate a hybrid program with assembly, C, and C++ code modules
; by: sean olson
; date: 11/29/25
;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
; data section for initialized variables
;------------------------------------------------------------------------------

section     .data

; db is a byte type variable that is held in memory. 
; it's a pointer, pointing to the first character in the string
MSG_HELLO    									db    13,10,"This is the manager function in manager.asm.",13,10,"Now calling get_user_input() in C++ module.",13,10,0
MSG_INPUT_CONFIMATION					db		13,10,"The manager function received %ld from the C++ function, get_user_input()", 13,10,0
MSG_GOODBYE    								db    13,10,"Now returning the input to main() in main.c.",13,10,0

;------------------------------------------------------------------------------
; bss section for unitialized global and static variables
;------------------------------------------------------------------------------
section     .bss

;------------------------------------------------------------------------------
; text section for program instructions
;------------------------------------------------------------------------------
section     .text

extern printf
extern get_user_input

global manager
manager:

		;----------------------
		; preserve the stack and base pointers
		push rbp
		mov rbp, rsp

		push r12

		;----------------------
		; put the stack in 16-byte alignment
		sub rsp, 16
		and rsp, -16

		;----------------------
    ; print a hello message
    mov rdi, MSG_HELLO
    call printf

		;----------------------
    ; call get user input and assign return value to r10
		call get_user_input
		mov r12, rax

		;----------------------
    ; print the confirmation
		mov rdi, MSG_INPUT_CONFIMATION
		mov rsi, r12
		call printf

		;----------------------
    ; print the goodbye message
		mov rdi, MSG_GOODBYE
    call printf
    
		;----------------------
    ; return the long to main()
		mov rax, r12

		;----------------------
		; restore the stack and base pointer
		pop r12

		mov rsp, rbp
		pop rbp

		ret

section .note.GNU-stack noalloc noexec nowrite progbits