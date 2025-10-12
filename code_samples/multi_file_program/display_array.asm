; ----------------------------------------------------------
; display_array.asm
; ----------------------------------------------------------


; ----------------------------------------------------------
; initialized-variable section
; ----------------------------------------------------------
section					.data

	; ---------------------------
	; strings
	MSG_GREET												db 			"In the display_array.asm code"
	MSG_GREET_LEN										equ			$-MSG_GREET


	MSG_GOOD_BYE										db 			"Leaving the display_array.asm code"
	MSG_GOOD_BYE_LEN								equ			$-MSG_GOOD_BYE	

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
	INT_VALUE												dq			64

; ----------------------------------------------------------
;  text section
; ----------------------------------------------------------
section .text
	global display_array
	extern libPuhfessorP_printSignedInteger64
	extern print_string
	extern print_newline

	; ---------------------------
	; void display_array()
	;
	;	register usage:
	;		rbp: preserved and restored to manage stack alignment
	;		r12: hold the array pointer
	;		r13: hold the array length
	display_array:

		; ------------
		; preserve and stack align
		push rbp
		push r12	
		push r13

		; ------------
		; print greeting	
    mov rdi, MSG_GREET 
    mov rsi, MSG_GREET_LEN  
    call print_string
		call print_newline

		; ------------
		; capture the arguments	
		mov	r12,	rdi
		mov r13,	rsi

		; ------------
		; print greeting
		mov	rdi, [INT_VALUE]
		call libPuhfessorP_printSignedInteger64
		call print_newline

		; ------------
		; print goodbye	
    mov rdi, MSG_GOOD_BYE
    mov rsi, MSG_GOOD_BYE_LEN  
    call print_string
		call print_newline

		; ------------
		; restore and stack align
		push r13
		push r12	
		push rbp		

		ret
