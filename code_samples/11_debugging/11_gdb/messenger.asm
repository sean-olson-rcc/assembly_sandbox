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


	MSG_DEMO_STRING									db			"This is a test", 10, 0


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
	global print_simple_string
	global print_newline
	global print_signed_int_64


	extern printf

; ---------------------------
	; void print_string(char * message)
	;
	;	register usage
	;		rbp:	the base pointer is preserved
	;		rsp: the stack pointer is moved to accomodate 16-byte alignment

	print_simple_string:		

		; ------------
		; preserve
		push rbp
		mov rbp, rsp

		; ------------
		; grab the argument	
		mov r8,	rdi

		and rsp, -16

		mov rdi,	MSG_DEMO_STRING
		; ------------
		; set the arguments and make the syscall			
		call printf

		; ------------
		; restore
		mov rsp, rbp
		pop rbp

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
		; add rsp, -16


		; ------------
		; restore - none
		pop rsp
		pop rbp

		ret
