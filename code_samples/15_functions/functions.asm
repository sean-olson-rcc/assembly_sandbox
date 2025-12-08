
;------------------------------------------------------------------------------
; title: functions.asm
; description: this is a code sample meant to demo assembly functions 
; by: sean olson
; date: 11/29/25
;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
; data section for initialized variables
;------------------------------------------------------------------------------
section .data

;---------------------
; c-strings
MSG_BEGIN											db					"Now inside the assembly entry point.",13,10,0
MSG_PRINT_INTS								db					"Now printing all integer arguments:",13,10,0
MSG_PRINT_CSTIRNG							db					"Now printing the received c-string:",13,10,0
MSG_PRINT_FLOATS							db					"Now printing the floats:",13,10,0

MSG_CALLING_ON_CPP						db					"Assembly module will now call on the C++ module.",13,10,0
MSG_STRING_INSIDE_ASM					db					"This string is owned by the assembly module:",13,10,0
MSG_RECIEVED_FLOAT						db					"The assembly module received this return value from the C++ module:",13,10,0

;---------------------
; numbers
FLOAT_B												dq					0.0
FLOAT_D												dq					0.0
FLOAT_SEND_B									dq					21983.129873873
FLOAT_SEND_D									dq					99887766.9999999
FLOAT_GOT_RETURN_VALUE				dq					0.0

;---------------------
; file descriptors
FD_STDOUT											equ 				1




;------------------------------------------------------------------------------
; text section for program instructions
;------------------------------------------------------------------------------
section .text

global my_assembly_function

;-----------------
; external functions from yasm_lib.so
extern print_cstring
extern print_newline
extern print_long
extern print_long
extern print_float
extern flush_output

extern my_cpp_function

extern printf

;--------------------------------------------
; void my_assembly_function()
;
;		register usage:
;			rbp:	preserved base pointer
;			rsp:	used to allocate memory	
;			r12:	store the "a" argument	
;			r13:	store the "c" argument	
;			r14:	store the "e" argument		

my_assembly_function:

	;--------------------------------------
	; prologue
	;-------------------
	push rbp
	mov rbp, rsp

	push r12
	push r13
	push r14

	;-------------------
	; set 16-byte stack alignment
	sub rsp, 16
	and rsp, -16

	;--------------------------------------
	; instructions
	;-------------------
	; capture the arguments
	mov	r12, rdi
	mov	r13, rsi
	mov	r14, rdx

	movsd	[FLOAT_B], xmm0
	movsd	[FLOAT_D], xmm1

	mov rdi, MSG_BEGIN
	call print_cstring

	;-------------------
	; print out the integers
	mov rdi, MSG_PRINT_INTS
	call print_cstring

	sub rsp, 8
	mov [rsp], r12
	mov rdi, rsp
	call print_long

	call print_newline

	sub rsp, 8
	mov [rsp], r13
	mov rdi, rsp
	call print_long

	call print_newline

	call flush_output

	add rsp, 16

	;-------------------
	; print out c-string
	mov rdi, MSG_PRINT_CSTIRNG
	call print_cstring

	mov rdi, r14
	call print_cstring
	call print_newline

	;-------------------
	; print the float values
	mov rdi, MSG_PRINT_FLOATS
	call print_cstring

	mov rdi, FLOAT_B
	call print_float
	call print_newline

	mov rdi, FLOAT_D
	call print_float
	call print_newline

	;-------------------
	; call the c++ function, my_cpp_function()

	mov rdi, MSG_CALLING_ON_CPP
	call print_cstring

	mov rdi, r12
	mov rsi, r13
	mov rdx, r14
	movsd xmm0, [FLOAT_SEND_B]
	movsd xmm1, [FLOAT_SEND_D]

	call my_cpp_function
	movsd [FLOAT_GOT_RETURN_VALUE], xmm0

	;-------------------
	; print the return message
	mov rdi, MSG_RECIEVED_FLOAT
	call print_cstring

	mov rdi, FLOAT_GOT_RETURN_VALUE
	call print_float
	call print_newline

	;--------------------------------------
	; epilogue
	;-------------------
	pop r14
	pop r13
	pop r12

	mov rsp, rbp	
	pop rbp

	ret
