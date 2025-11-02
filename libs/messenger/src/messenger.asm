; ;---------------------------------------
; ; title: messenger.asm
; ; description: a simple library to print strings to standard out, compiled for ubuntu x86_64
; ; by: sean olson
; ;---------------------------------------


; ;---------------------------------------
; ; .data section -- predefined variables which live on the heap
; ;---------------------------------------

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
	global print_message
	global print_newline
	global print_signed_int_64

	extern libPuhfessorP_printSignedInteger64

; ---------------------------
	; void print_message(char * message, int length)
	;
	;	register usage
	;		r8:	string to be printed
	;		r9:	string length
	print_message:		

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


	print_signed_int_64:

		; ------------
		; preserve - none
		push rbp
		push rsp

		; ------------
		; grab the arguments	
		mov r8,	rdi

		
		; ------------
		; set the arguments and make the syscall			
		mov rdi, r8
		add rsp, -16
		call libPuhfessorP_printSignedInteger64

		; ------------
		; restore - none
		pop rsp
		pop rbp

		ret
