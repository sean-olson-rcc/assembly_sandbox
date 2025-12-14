;------------------------------------------------------------------------------
; title: Bitwise Operation
; description:
; by: sean olson
; date: 12/13/2025
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; data section for initialized variables
;------------------------------------------------------------------------------
section					.data

;--------------------
; c-strings
MSG_HELLO												db							"Hello, my name is Sean Olson",13,10,0
MSG_HELLO_LEN										equ							$-MSG_HELLO

;--------------------
; integers
BITS_A													dq							0xFFFF000FF000FFFF
BITS_B													dq							0xF000FF0FF0FF000F

NEGATIVE_NUMBER									dq							-12

;--------------------
; system calls
SYS_WRITE												equ							1
SYS_EXIT												equ							60

;--------------------
; file descriptors
FD_STDOUT												equ							1

;--------------------
; exit codes
EXIT_SUCCESS										equ							0


;------------------------------------------------------------------------------
;  uninitialized-variable
;------------------------------------------------------------------------------
section					.bss

;------------------------------------------------------------------------------
;  text section
;------------------------------------------------------------------------------
section .text

global _start

_start:

	;--------------------
	; prologue
	push rbp
	mov rbp, rsp

	push r12
	push r13
	push r14
	push r15

	;--------------------
	; print hello
	mov rax, SYS_WRITE
	mov	rdi, FD_STDOUT
	mov	rsi, MSG_HELLO
	mov	rdx, MSG_HELLO_LEN
	syscall

	;--------------------
	; demo bitwise AND
	mov	r10, [BITS_A]
	mov	r11, [BITS_B]
	mov	r12, r10
	and r12, r11

	;--------------------
	; non-operational instruction for break point
	nop

	;--------------------
	; demo bitwise OR
	mov	r10, [BITS_A]
	mov	r11, [BITS_B]
	mov	r12, r10
	or r12, r11

	;--------------------
	; non-operational instruction for break point
	nop

	;--------------------
	; demo bitwise XOR
	mov	r10, [BITS_A]
	mov	r11, [BITS_B]
	mov	r12, r10
	xor r12, r11

	;--------------------
	; non-operational instruction for break point
	nop

	;--------------------
	; demo bitwise NOT
	mov	r10, [BITS_A]
	mov r11, r10
	not r11

	;--------------------
	; non-operational instruction for break point
	nop

	;--------------------
	; demo bitwise rotation
	mov	r10, [BITS_A]
	mov	r11, [BITS_A]
	mov	r12, [BITS_A]
	mov	r13, [BITS_A]
	mov	r14, [BITS_A]

	rol r11, 1
	rol r12, 2
	ror r13, 1
	ror r14, 2

	;--------------------
	; non-operational instruction for break point
	nop

	;--------------------
	; demo logical shift 
	mov r10, [NEGATIVE_NUMBER]
	
	;--------------------
	; use logical shifts -- won't work for mathematical manipulation
	mov r11, r10
	shl r11, 2

	mov r12, r10
	shr r12, 2

	;--------------------
	; use arithmetic shifts -- respects that original number is two's compliment
	mov r13, r10
	sal r13, 2

	mov r14, r10
	sar r14, 2

	;--------------------
	; non-operational instruction for break point
	nop

	;--------------------
	; epilogue
	pop r15
	pop r14
	pop r13
	pop r12

	mov rsp, rbp
	pop rbp

	mov	rdi,	EXIT_SUCCESS
	mov rax,	SYS_EXIT
	syscall