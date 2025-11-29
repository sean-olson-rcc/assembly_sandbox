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

; db is a byte type variable that is held in memory. 
; it's a pointer, pointing to the first character in the string
HELLO_STRING    					db     13,10,"This is the manager function in manager.asm.",13,10,"Now returning a long to the main() function in the C++ driver.",13,10,0
RETURN_VALUE							dq		 42	


;------------------------------------------------------------------------------
; bss section for unitialized global and static variables
;------------------------------------------------------------------------------
section     .bss

;------------------------------------------------------------------------------
; text section for program instructions
;------------------------------------------------------------------------------
section     .text

extern printf

global manager
manager:

		;----------------------
		; preserve the stack and base pointers
		push rbp
		mov rbp, rsp

		;----------------------
		; put the stack in 16-byte alignment
		sub rsp, 16
		and rsp, -16

		;----------------------
    ; print a hello message
    mov rdi, HELLO_STRING
    call printf
    
		;----------------------
    ; return the long to main()
		mov rax, [RETURN_VALUE]

		;----------------------
		; restore the stack and base pointer
		mov rsp, rbp
		pop rbp

		ret

section .note.GNU-stack noalloc noexec nowrite progbits