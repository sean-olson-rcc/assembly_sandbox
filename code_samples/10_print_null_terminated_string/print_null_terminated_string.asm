;------------------------------------------------------------
; name: print_null_terminated_string.asm
; attribution: copied from code-review with RCC Professor Michael Peralta
; date: 11/3/2025
;------------------------------------------------------------

;------------------------------------------------------------
; initialized variables
;------------------------------------------------------------
section .data

; c-strings
NULL_TERMINATED_STRING		db			"Hello, this is an example of a null-terminated string! ", 0
CRLF											db			13, 10, 0

; syscall codes
SYS_WRITE							equ			1
SYS_EXIT							equ			60

; file descriptors
FD_STDOUT							equ			1

; exit codes
EXIT_SUCCESS					equ			0

;------------------------------------------------------------
; instructions
;------------------------------------------------------------
section .text

global main

;-----------------------------
;	entry point
;
;		register usage:
;			r12: 	length of string

main:

	;--------------	
	; preserve
	push r12

	mov	rdi,	NULL_TERMINATED_STRING
	mov	rsi,	FD_STDOUT
	call print_null_terminated_string
	call crlf

	;--------------	
	; restore
	pop r12
	mov	rax,	EXIT_SUCCESS
	
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


