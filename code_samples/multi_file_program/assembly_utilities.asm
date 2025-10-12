; ----------------------------------------------------------
; assembly_utilities.asm
; ----------------------------------------------------------


; ----------------------------------------------------------
; initialized-variable section
; ----------------------------------------------------------
section					.data

	; ---------------------------
	; strings
	MSG_CRLF												db 			13, 10
	MSG_CRLF_LEN										equ			$-MSG_CRLF


	; ---------------------------
	; system calls
	SYS_WRITE												equ			1

	; ---------------------------
	; file descriptors
	FD_STDOUT												equ			1


; ----------------------------------------------------------
;  text section
; ----------------------------------------------------------
section .text
	global print_string
	global print_newline

; ---------------------------
	; void print_string(char * message, int length)
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
	; void print_newline(void)
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