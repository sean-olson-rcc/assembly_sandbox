; ----------------------------------------------------------
; simple example of integer division
; ----------------------------------------------------------

; ----------------------------------------------------------
; data section
; ----------------------------------------------------------
section					.data

; ---------------------------
; c-strings
MSG_DIVISION_QUOTIENT						db 			"The division result (quotient) is: ", 0
MSG_DIVISION_REMAINDER					db			"The division remainder is: ", 0

; ---------------------------
; return values
RETURN_VALUE										equ			7  ;unused to allow remainder to be returned to the calling function of math()

; ---------------------------
; integers
MY_INT_A												dq			233
MY_INT_B												dq			256

; ----------------------------------------------------------
;  uninitialized variables
; ----------------------------------------------------------
section					.bss



; ----------------------------------------------------------
; text section
; ----------------------------------------------------------
section					.text

extern	print_cstring
extern 	print_newline
extern 	print_long

global math

; ---------------------------
; int math()
;
;		register usage
;			rbp:	the base pointer is preserved
;			rsp: the stack pointer is moved to accomodate 16-byte alignment

math:

	;------------------------------------
	; prologue
	;------------------
	push rbp 
	mov rbp, rsp

	;------------------
	; set the stack pointer to 16-byste alignment
	sub rsp, 16
	and rsp, -16	

	;------------------------------------
	; instructions
	;------------------

	call divide_test

	;------------------
	; pass through rax return value from divide_test to calling function
	

	;------------------------------------
	; epilogue
	;------------------

	mov rsp, rbp
	pop rbp

	ret

; ---------------------------
; long divide_test()
;
; 	register usage:
;			rbp:	the base pointer is preserved
;			rsp: the stack pointer is moved to accomodate 16-byte alignment
;			r12: to store the divisor
;			r14: to store the quotient
;			r15: to store the remainder

divide_test:
	;------------------------------------
	; prologue
	;------------------
	push rbp 
	mov rbp, rsp

	push 	r12
	push	r14
	push	r15

	;------------------
	; set the stack pointer to 16-byste alignment
	sub rsp, 16
	and rsp, -16		

	;------------------------------------
	; instructions
	;------------------

	; ---------------------------
	; setup rax with the numerator
	mov	rax, qword [MY_INT_B]				

	; ---------------------------
	; note: because integer division requires  usage  of the A and D registers 
	; for the numerator (e.g., rdx and rax for a 64 signed integer), the rdx needs
	; to be padded with either 1's (in the event of a negative number) or 0's (in
	; the event of a positive number).  The instruction `cqo` stretches the 64-bit rax 
	; register onto the rdx register, using the appropriate pad for the value in rax.

	; ---------------------------
	; pad the rdx register
	cqo

	; ---------------------------
	; set up the divisor
	mov	r12, qword [MY_INT_A]				

	; ---------------------------
	; note: both rdx and rax are overwritten. by the division process.  after division, 
	; rax will contain the quotient, and rdx will contain the remainder 

	; ---------------------------
	; divide the numerator (rdx:rax) by the divisor (r12)
	idiv	r12											

	; ---------------------------
	; note: because both rax and rdx can be quickly destroyed, preserve the results
	mov	r14, 	rax
	mov	r15,	rdx

	; ---------------------------
	; print out the prefix to the quotient

	mov	rdi,	MSG_DIVISION_QUOTIENT
	call print_cstring

	; ---------------------------
	; call the libP function to print the quotient

	sub rsp, 8
	mov [rsp], r14
	mov	rdi, rsp
	call	print_long
	call print_newline

	; ---------------------------
	; print out the prefix to the remainder
	mov	rdi,	MSG_DIVISION_REMAINDER
	call print_cstring

	; ---------------------------
	; call the libP function to print the quotient
	sub rsp, 8
	mov [rsp], r15
	mov rdi, rsp
	call	print_long
	call print_newline

	; ---------------------------
	; restore the stack pointer 
	add rsp, 16

	mov	rax,	r15

	;------------------------------------
	; epilogue
	;------------------
	pop r15
	pop r14
	pop r12

	mov rsp, rbp
	pop rbp

	ret

