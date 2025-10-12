; ----------------------------------------------------------
; manager.asm
; ----------------------------------------------------------


; ----------------------------------------------------------
; initialized-variable section
; ----------------------------------------------------------
section					.data

	; ---------------------------
	; strings
	MSG_GREET												db 			"In the_asm_file.asm"
	MSG_GREET_LEN										equ			$-MSG_GREET

	; ---------------------------
	; system calls
	SYS_WRITE												equ			1

	; ---------------------------
	; file descriptors
	FD_STDOUT												equ			1

	; ---------------------------
	; debug data
	int_value												dq			100

; ----------------------------------------------------------
;  text section
; ----------------------------------------------------------
section .text
	global int_from_asm_a

	; ---------------------------
	; int int_from_asm_a()

	int_from_asm_a:

		; ------------
		; print greeting	
		mov rax, SYS_WRITE
    mov rdi, FD_STDOUT 
    mov rsi, MSG_GREET 
    mov rdx, MSG_GREET_LEN  
    syscall

		; ------------
		; set return value
		mov rax, int_value
		ret