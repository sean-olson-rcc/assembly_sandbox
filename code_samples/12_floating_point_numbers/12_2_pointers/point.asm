;---------------------------------------
; title: point.asm
; date: 11/16/2025
; by: transcribed by Sean Olson from a video lesson by Professor Paul Peralta
;---------------------------------------

;---------------------------------------
; .data section for initialized variables
;---------------------------------------

section .data

	;----------
	; c-strings

	MSG_BEGIN										db			"Now inside the point module.", 0
	MSG_RECEIVED_CSTRING				db			"Now printing the received c-string: ", 0
	MSG_STRING_INSIDE_ASM				db			"This string is owned by the assembly module.", 0

	CRLF												db			13,10,0

;----------
; numbers

LONG_INSIDE_ASM								dq			12345
FLOAT_INSIDE_ASM							dq			1.2345


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

global point

extern	hey_driver_print_this

;-----------------------------
;	void point(char * print_me, long * change_me)
;
;		register usage:
;			r12: 	pointer to the first character of the c-string to be printed
;			r13:	pointer to the long to modify

point:

	;----------
	; preserve
	push r12
	push r13

	;----------
	; decrement the stack-pointer register for 16-byte alignment	
	sub rsp, 8

	;----------
	; save the arguments
	mov	r12, rdi
	mov	r13, rsi

	;----------
	; print a welcome message
	mov rdi, MSG_BEGIN
	mov	rsi, FD_STDOUT
	call print_null_terminated_string
	call crlf 

	;----------
	; print the received c-string prefix
	mov rdi, MSG_RECEIVED_CSTRING
	mov	rsi, FD_STDOUT
	call print_null_terminated_string

	mov rdi, r12
	mov	rsi, FD_STDOUT
	call print_null_terminated_string
	call crlf 	


	;----------
	; increment the long int passed by pointer, stored in r13
	inc qword [r13]


	;----------
	; call the driver's print function
	mov	rdi, MSG_STRING_INSIDE_ASM
	mov	rsi, LONG_INSIDE_ASM
	mov	rdx, FLOAT_INSIDE_ASM
	call hey_driver_print_this


	;----------
	; restore the stack pointer register
	add rsp, 8

	;----------
	; restore the callee -saved registers
	pop r13
	pop r12

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