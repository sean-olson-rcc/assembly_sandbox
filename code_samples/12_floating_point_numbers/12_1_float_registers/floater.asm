;---------------------------------------
; title: floater.asm
; date: 11/15/2025
; by: transcribed by Sean Olson from a video lesson by Professor Paul Peralta
;---------------------------------------

;---------------------------------------
; .data section for initialized variables
;---------------------------------------

section .data

	;----------
	; c-strings

	MSG_ASK_INT									db			"Please enter an integer: ", 0
	MSG_ECHO_INT								db			"The integer you entered was: ", 0
	MSG_ASK_FLOAT								db			"Please enter a float: ", 0
	MSG_ECHO_MODIFIED_FLOAT			db			"The modified float is: ", 0
	MSG_INT_BY_FLOAT						db			"The integer multiplied by the float is: ", 0

	CRLF												db			13,10,0

;----------
; floats

THE_FLOAT											dq			0.0
THE_MODIFIED_FLOAT						dq			0.0
INT_MULT_BY_FLOAT							dq			0.0
FLOAT_MULTIPLIER							dq			3.333


;----------
; system calls

SYS_WRITE											equ			1	


;----------
; file descriptors

FD_STDOUT											equ			1

;---------------------------------------
; .text section
;---------------------------------------

section .text

global floater

extern	libPuhfessorP_printSignedInteger64
extern	libPuhfessorP_inputSignedInteger64
extern	libPuhfessorP_printFloat64
extern	libPuhfessorP_inputFloat64

floater:

	;----------
	;
	call float_convert_tests
	; call crlf

	;----------
	;
	movsd xmm0, [THE_MODIFIED_FLOAT]

	ret

;-----------------------------
;	void float_convert_tests()
;
;		register usage:
;			r12: 	the integer input

float_convert_tests:

	;----------
	; preserve
	push rbp
	push r12
	mov rbp, rsp

	;----------
	; get user integer input
	mov	rdi, MSG_ASK_INT
	mov	rsi, FD_STDOUT
	call print_null_terminated_string

	;----------
	; stack align for 16-byte
	; and	rsp, -16
	call libPuhfessorP_inputSignedInteger64
	mov	r12, rax

	;----------
	; get user float input
	mov	rdi, MSG_ASK_FLOAT
	mov	rsi, FD_STDOUT
	call print_null_terminated_string

	call libPuhfessorP_inputFloat64
	movsd	[THE_FLOAT], xmm0

	;----------
	; echo the integer back to the user
	mov	rdi,	MSG_ECHO_INT
	mov	rsi, FD_STDOUT
	call print_null_terminated_string
	mov	rdi, r12
	call	libPuhfessorP_printSignedInteger64
	call crlf

	;----------
	; convert the integer to a float and multiply by FLOAT_MULTIPLIER (3.333)
	; we could lose data here on the assumption that the int is only 32 bits
	cvtsi2sd	xmm0, r12
	mulsd	xmm0,	[FLOAT_MULTIPLIER]
	movsd	[THE_MODIFIED_FLOAT], xmm0	;float registers are not callee saved, so don't assume it will be there after a method call

	;----------
	; give the user feedback about the modified float
	mov	rdi, MSG_ECHO_MODIFIED_FLOAT
	mov	rsi, FD_STDOUT
	call print_null_terminated_string
	movsd	xmm0,	[THE_MODIFIED_FLOAT]
	call libPuhfessorP_printFloat64
	call crlf

	;----------
	; multiply the integer by the float and save
	cvtsi2sd	xmm0, r12
	mulsd	xmm0, [THE_FLOAT]
	movsd	[INT_MULT_BY_FLOAT], xmm0

	;----------
	; give the user feedback about integer multiplied by the float
	mov	rdi, MSG_INT_BY_FLOAT
	mov	rsi, FD_STDOUT
	call print_null_terminated_string
	movsd	xmm0,	[INT_MULT_BY_FLOAT]
	call libPuhfessorP_printFloat64
	call crlf	

	;----------
	; restore
	mov rsp, rbp
	pop r12
	pop rbp

	ret


;-----------------------------
;	void print_null_terminated_string(char * cstring, long file_handle)
;
;		register usage:
;			r12: 	csrting pointer
;			r13: 	file handle
;			r14: 	cstring's length

print_null_terminated_string:

	;--------------	
	; preserve
	push r12
	push r13
	push r14

	;--------------	
	; assign incoming arguments to r12 and r13 registers
	mov	r12,	rdi 	; rdi is pointer to the first address of the character-address array
	mov	r13,	rsi		; rsi is the file descriptor used for output

	;--------------	
	; use strlen to calculate the length of the string and assign the result to r14
	mov	rdi, 	r12
	call strlen
	mov	r14, rax

	;--------------	
	; use an assembly system call to write the string
	mov	rax, 	SYS_WRITE
	mov	rdi,	r13
	mov	rsi,	r12
	mov	rdx,	r14
	syscall	

	;--------------	
	; restore
	pop r14
	pop r13
	pop r12

	ret

;-----------------------------
;	long strlen(char * cstring)
;
;		register usage:
;			r12: 	running pointer
;			r13: 	string length

strlen:

	;--------------	
	; preserve
	push r12
	push r13

	;--------------	
	; initialize the loop
	strlen_loop_init:
		mov	r12,	rdi		; grab the argument for the string pointer and preserve it in the r12 register
		mov	r13,	0			; initialize the character counter

	;--------------	
	; strlen loop top	
	strlen_loop_top:

		cmp byte [r12], 0			; check the character at the address referenced in the r12 register
		jne strlen_loop_body	; if you have not found a 0 (i.e., null), then the string is not terminated (conditional jumps range is only 128 bytes)	

		jmp strlen_loop_done 	; this structure shortens the distance fot the conditinal jump

	strlen_loop_body:
		inc r13
		inc r12
		jmp strlen_loop_top

	strlen_loop_done:	
		mov rax, r13
	;--------------	
	; restore
	pop r13
	pop r12

	ret	


;-----------------------------
; void crlf()
;
;		register usage:
;			none

crlf: 
	mov rdi, CRLF
	mov	rsi, FD_STDOUT
	call print_null_terminated_string

	ret