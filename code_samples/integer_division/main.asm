; ----------------------------------------------------------
; simple example of integer division
; ----------------------------------------------------------


; ----------------------------------------------------------
; data section
; ----------------------------------------------------------
section					.data

; ---------------------------
; c-strings
MSG_DIVISION_QUOTIENT						db 			"The division result (quotient) is: "
MSG_DIVISION_QUOTIENT_LEN				equ			$-MSG_DIVISION_QUOTIENT
MSG_DIVISION_REMAINDER					db			"The division remainder is: "
MSG_DIVISION_REMAINDER_LEN			equ			$-MSG_DIVISION_REMAINDER

CRLF														db			13, 10
CRLF_LEN												equ			$-CRLF

; ---------------------------
; system calls
SYS_WRITE												equ			1

; ---------------------------
; file descriptors
FD_STDOUT												equ			1

; ---------------------------
; return values
RETURN_VALUE										equ			7

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
extern	libPuhfessorP_printSignedInteger64
extern	libPuhfessorP_printRegisters

global math

; ---------------------------
; math()
math:

	call divideTest

	mov 	rax, 	RETURN_VALUE					; move 7 into rax (the return code)
	ret

; ---------------------------
; void divide_test()
;
; register usage:
;		r12: to store the divisor
;		r14: to store the quotient
;		r15: to store the remainder

divide_test:
	; prologue
	push 	r12
	push	r14
	push	r15

	mov	rax, qword [MY_INT_B]				; setup rax with the numerator
	; ---------------------------
	; note: because integer division requires  usage  of the A and D registers 
	; for the numerator (e.g., rdx and rax for a 64 signed integer), the rdx needs
	; to be padded with either 1's (in the event of a negative number) or 0's (in
	; the event of a positive number).  The instruction `cqo` stretches the 64-bit rax 
	; register onto the rdx register, using the appropriate pad for the value in rax.
	cqo

	mov	r12, qword [MY_INT_A]				; det up the divisor

	; ---------------------------
	; note: both rdx and rax are overwritten. by the division process.  after division, 
	; rax will contain the quotient, and rdx will contain the remainder 
	idiv	r12												; divide the numerator (rdx:rax) by the divisor (r12)

	; ---------------------------
	; note: because both rax and rdx can be quickly destroyed, preserve the results
	mov	r14, 	rax
	mov	r15,	rdx

	; ---------------------------
	; print out the prefix to the quotient
	mov rax, 	SYS_WRITE
	mov rdi,	FD_STDOUT
	mov	rsi,	MSG_DIVISION_QUOTIENT
	mov	rdx,	MSG_DIVISION_QUOTIENT_LEN
	syscall

	; ---------------------------
	; call the libP function to print the quotient
	mov	rdi, r14
	call	libPuhfessorP_printSignedInteger64
	call crlf

		; ---------------------------
	; print out the prefix to the remainder
	mov rax, 	SYS_WRITE
	mov rdi,	FD_STDOUT
	mov	rsi,	MSG_DIVISION_REMAINDER
	mov	rdx,	MSG_DIVISION_REMAINDER_LEN
	syscall

	; ---------------------------
	; call the libP function to print the quotient
	mov	rdi, r15
	call	libPuhfessorP_printSignedInteger64
	call crlf

	; epilogue
	pop r15
	pop r14
	pop r12

	ret

; ---------------------------
; void crlf()
crlf:

	mov rax, 	SYS_WRITE
	mov rdi,	FD_STDOUT
	mov	rsi,	CRLF
	mov	rdx,	CRLF_LEN
	syscall
	ret
