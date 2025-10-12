; ----------------------------------------------------------
; the_asm_file.asm
; ----------------------------------------------------------


; ----------------------------------------------------------
; initialized-variable section
; ----------------------------------------------------------
section					.data

	; ---------------------------
	; strings
	MSG_GREET												db 			"In the_asm_file.asm"
	MSG_GREET_LEN										equ			$-MSG_GREET


	MSG_CALLING_OTHER_ASM						db 			"In the_asm_file.asm"
	MSG_CALLING_OTHER_ASM_LEN				equ			$-MSG_CALLING_OTHER_ASM	

	MSG_CRLF												db 			13, 10
	MSG_CRLF_LEN										equ			$-MSG_CRLF

	; ---------------------------
	; system calls
	SYS_WRITE												equ			1

	; ---------------------------
	; file descriptors
	FD_STDOUT												equ			1

	; ---------------------------
	; debug data
	int_value												dq			100
	int_array 											dq 			10, 20, 30, 40, 50 
	int_array_len										dq			5	

; ----------------------------------------------------------
;  text section
; ----------------------------------------------------------
section .text
	global int_from_asm_a
	extern display_array

	; ---------------------------
	; int int_from_asm_a()
	int_from_asm_a:

		; ------------
		; print greeting	
    mov rdi, MSG_GREET 
    mov rsi, MSG_GREET_LEN  
    call print_string
		call print_newline

		; ------------
		; set return value
		mov rax, [int_value]
		ret


	; ---------------------------
	; void print_string()
	;
	;	register usage
	;		r8:	string to be printed
	;		r9:	string length
	print_string:		

		; ------------
		; preserve - none

		; ------------
		; grab the arguments	
		mov r8,	rdi
		mov	r9,	rsi
		
		; ------------
		; set the arguments and make the syscall			
		mov rax,	SYS_WRITE
		mov	rdi,	FD_STDOUT
		mov	rsi,	r8
		mov	rdx,	r9
		syscall

		; ------------
		; restore - none

		ret

	; ---------------------------
	; void print_newline()
	print_newline:	
		
		; ------------
		; preserve - none
		
		; ------------
		; set the arguments and make the syscall			
		mov rax,	SYS_WRITE
		mov	rdi,	FD_STDOUT
		mov	rsi,	MSG_CRLF
		mov	rdx,	MSG_CRLF_LEN
		syscall

		; ------------
		; restore - none

		ret	