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
	display_array:

		; ------------
		; print greeting	
    mov rdi, MSG_GREET 
    mov rsi, MSG_GREET_LEN  
    call print_string
		call print_newline




		; ------------
		; print goodbye	
    mov rdi, MSG_GOOD_BYE
    mov rsi, MSG_GOOD_BYE_LEN  
    call print_string
		call print_newline

		ret
