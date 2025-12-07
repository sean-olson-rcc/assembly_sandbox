;---------------------------------------
; title: math.asm
; date: 11/18/2025
; by: transcribed by Sean Olson from a video lesson by Professor Paul Peralta
;---------------------------------------

;---------------------------------------
; data section for initialized variables
;---------------------------------------

section .data

;-------------------
; c-strings

MSG_MULT_IMMEDIATE_PREFIX								db				"The result of multiplying immediates is: *** ",0
MSG_MULT_IMMEDIATE_SUFFIX								db				" ***",13,10,0
MSG_MULT_GOLBAL_PREFIX									db				"The result of multiplying globals is: *** ",0
MSG_MULT_GLOBAL_SUFFIX									db				" ***",13,10,0

CRLF																		db				13,10,0

;-------------------
; return values

RETURN_VALUE														equ				7

;-------------------
; integers

MY_INT_A																dq				-233
MY_INT_B																dq				256

;---------------------------------------
; text section for instructions
;---------------------------------------

section .text

extern print_cstring
extern print_long
extern flush_output

global math

; ---------------------------
; int math()
;
;		register usage
;			rbp:	the base pointer is preserved
;			rsp: the stack pointer is moved to accomodate 16-byte alignment

math:

	;-------------------
	; prologue
	push rbp
	mov rbp, rsp

	;-------------------
	; set 16-byte stack alignment
	sub rsp, 16
	and rsp, -16

	call multiply_test

	mov	rax, RETURN_VALUE

	;-------------------
	; epilogue

	mov rsp, rbp	
	pop rbp

	ret


; ---------------------------
; int multiply_test()
;
;		register usage
;			rbp:	the base pointer is preserved
;			rsp: the stack pointer is moved to accomodate 16-byte alignment
;			r12: hold an immediate for multiplication 
;			r13: hold an immediate for multiplication 
;			r14: hold a global for multiplication
;			r15: hold a global for multiplication

multiply_test:
	;-------------------
	; prologue
	push rbp
	mov rbp, rsp

	push r12
	push r13
	push r14
	push r15

	;-------------------
	; set 16-byte stack alignment
	sub rsp, 16
	and rsp, -16

	;-------------------
	; perform multiplication using an immediate values
	mov r12, 233
	mov	r13, 256
	imul r12, r13

	mov rdi, MSG_MULT_IMMEDIATE_PREFIX
	call print_cstring
	call flush_output

	;----------------------------------------
	; NOTE: In assembly, you're confronted with the reality that values can exist in three different "places":
	; 1. Immediates — literal values encoded in the instruction itself (mov r12, 233)
	; 2. Registers — fast, temporary storage with no memory address
	; 3. Memory — stack, heap, or data section; only these have addresses
	;
	; In this case the immediate value lives in the register, there is no address and the print_long function 
	; expects an address not a value (that's the contract), so the value in the r12 register need to be placed 
	; in memory and that address then sent to the print_long fucntion

	;-------------------
	; allocate stack-frame memory and save r12 to it
	sub rsp, 8
	mov [rsp], r12

	;-------------------
	; call the print_long() function in the yasm_util library
	mov rdi, rsp
	call print_long
	call flush_output

	;-------------------
	; return the stack pointer to it's original address
	add rsp, 8

	mov rdi, MSG_MULT_IMMEDIATE_SUFFIX
	call print_cstring
	call flush_output

	;-------------------
	; perform multiplication using an global values
	mov r14, [MY_INT_A]
	mov	r15, [MY_INT_B]
	imul r14, r15	

	inc qword r14
	add r14, 5

	;-------------------
	; increment r14 by one and add 5

	mov rdi, MSG_MULT_GOLBAL_PREFIX
	call print_cstring
	call flush_output

	;-------------------
	; allocate stack-frame memory and save r12 to it
	sub rsp, 8
	mov [rsp], r14

	;-------------------
	; call the print_long() function in the yasm_util library
	mov rdi, rsp
	call print_long
	call flush_output

	;-------------------
	; return the stack pointer to it's original address
	add rsp, 8

	mov rdi, MSG_MULT_GLOBAL_SUFFIX
	call print_cstring
	call flush_output


	;-------------------
	; epilogue
	pop r15
	pop r14
	pop r13
	pop r12

	mov rsp, rbp	
	pop rbp

	ret

	section .note.GNU-stack noalloc noexec nowrite progbits