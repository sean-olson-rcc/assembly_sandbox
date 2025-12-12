;------------------------------------------------------------------------------
; title: 
; description: this 
; by: sean olson
; date: 11/29/25
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; data section for initialized variables
;------------------------------------------------------------------------------
section					.data

;--------------------
; c-strings
MSG_HELLO												db							"Hello, my name is Sean Olson",13,10,0

;--------------------
; integers
MY_LONG_INT											dq							98728176287632
MY_DWORD_INT										dd 							276276276
MY_WORD_INT											dw 							62111
MY_BYTE_INT											db 							222

;--------------------
; number array
;
; note: normally this would be declared in the .bss section, but for a small 
; array, it can be placed in the data section
MY_SMALL_ARRAY									dq							1111111,2222222

;--------------------
; system calls
SYS_WRITE												equ							1
SYS_EXIT												equ							60

;--------------------
; file descriptors
FD_STDIN												equ							0
FD_STDOUT												equ							1

;--------------------
; constants
EXIT_SUCCESS										equ							0


; ;------------------------------------------------------------------------------
; ;  uninitialized-variable
; ;------------------------------------------------------------------------------
; section					.bss


;------------------------------------------------------------------------------
;  text section
;------------------------------------------------------------------------------
section .text

global main

extern 	print_cstring
extern	print_newline

; ---------------------------
; void main()
;
; 	register usage:
;			none
main:

	call say_hello

	call move_data_around

	mov	rax,	SYS_EXIT
	mov rdi,	EXIT_SUCCESS
	syscall

; ---------------------------
; void move_data_around()
;
; 	register usage:
;			rbp:	the base pointer is preserved
;			rsp: the stack pointer is moved to accomodate 16-byte alignment
;			r10:
;			r11:
;			r12:
;			r13:
;			r14:
;			r15:

move_data_around:

	;----------------------------------------
	; prologue
	;--------------------
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15

	sub rsp, 16
	and rsp, -16

	;----------------------------------------
	; instructions
	;--------------------
	; move an immediate into r10
	mov r10, 12876

	;--------------------
	; clear out r11, then move r10 into it
	xor r11, r11
	mov r11, r10

	;--------------------
	; move a quadword from memory to r12
	mov	r12, qword [MY_LONG_INT]

	;--------------------
	; move a dword (double word) from memory to r13
	xor r13, r13
	mov r13d,	dword [MY_DWORD_INT]

	;--------------------
	; move a word from memory to r14
	xor r14, r14
	mov r14w,	word [MY_WORD_INT]

	;--------------------
	; move a byte from memory to r15
	xor r15, r15
	mov r15b,	byte [MY_BYTE_INT]

	;--------------------
	; non-operation so the debugger breaks
	nop

	;--------------------
	; prove that data size matters by specifying a bad data size for the LONG then the BYTE
	xor r12, r12
	mov	r12b, byte [MY_LONG_INT]
	mov	r15, qword [MY_BYTE_INT]

	;--------------------
	; non-operation so the debugger breaks
	nop

	;--------------------
	; prove that symbols are pointers and need to be dereferenced
	mov	r10, 	MY_LONG_INT
	mov	r11,	[MY_LONG_INT]

	;--------------------
	; move the first value in the SMALL_ARRAY to r12
	mov r12,	[MY_SMALL_ARRAY]

	;--------------------
	; move the second vlaue in the SMALL_ARRAY to r13
	mov r13,	[MY_SMALL_ARRAY + 8]	 

	;--------------------
	; move the pointer to the first value in the SMALL_ARRAY to r14
	mov r14,	[MY_SMALL_ARRAY + 8]	 

	;--------------------
	; move the pointer to the second value in the SMALL_ARRAY to r15
	lea r15 [MY_SMALL_ARRAY + 8]

	;--------------------
	; non-operation so the debugger breaks
	nop


	;----------------------------------------
	; epilogue
	;--------------------
	pop r15
	pop r14
	pop r13
	pop r12

	mov rsp, rbp
	pop rbp

	ret

; ---------------------------
; void say_hello()
;
; 	register usage:
;			rbp:	the base pointer is preserved
;			rsp: the stack pointer is moved to accomodate 16-byte alignment

say_hello:

	push rbp
	mov rbp, rsp

	sub rsp, 16
	and rsp, -16

	mov rdi, MSG_HELLO
	call print_cstring

	call print_newline

	mov rsp, rbp
	pop rbp

	ret



	


