;------------------------------------------------------------
; name: cli_args.asm
; attribution: copied from code-review with RCC Professor Michael Peralta
; date: 11/3/2025
;------------------------------------------------------------


;------------------------------------------------------------
; initialized variables
;------------------------------------------------------------
section .data

; strings
MSG_INTRO							db			"The CLI Args demo module has started ", 0
MSG_BEGIN_PRINTING		db			"Begin printing all CLI arguments", 0
MSG_GOODBYE						db			"Program now exiting. Goodbye!", 0

CRLF									db			"13, 10, 0"

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
;			r12: 	number of arguments (int argc)
;			r13:	argument char pointers (char * argv[])
;			r14:	current argument index
;			r15:	current char pointer
main:

	;--------------	
	; preserve
	push r12
	push r13
	push r14
	push r15

	;--------------	
	; grab the incoming arguments
	; analgous to the C-main signature: int main(long argc, char * argv[])
	; argv is a character pointer, which points to an array of character pointers

	mov	r12,	rdi		; will be a long integer representing the total number of arguments
	mov	r13,	rsi 	; will be a character pointer, pointing to the address of the first character pointer

	call intro

	mov	rdi,	MSG_BEGIN_PRINTING
	mov	rsi,	FD_STDOUT
	call	print_null_terminated_string
	call	crlf

	;--------------	
	; initialize the loop
	main_loop_init:

		mov	r14,	0			; set the argument-index register to the first position 
		mov	r15,	r13		; set the charater pointer to the first argument pointer

	;--------------	
	; main loop top
	main_loop_top:

		;--------------	
		; check for completion
		cmp r14, r12				; compare the current argument index to the number of argumants
		jge	main_loop_done	; if the current index is great or equal, jump to main_loop done

	;--------------	
	; main loop body
	main_loop_body:

		;--------------
		; print the referenced argument and move the cursor to the next line
		mov	rdi,	[r15]
		mov	rsi,	FD_STDOUT
		call print_null_terminated_string
		call crlf
		
		;--------------
		; increment the argument index and move the argument pointer to the next address in the array 
		inc r14
		add r15,	8

		;--------------
		; go back to the top of the loop 
		jmp main_loop_top

	;--------------	
	; main loop done
	main_loop_done:

		call goodbye		
		jmp exit

	;--------------	
	; exit routine
	exit: 
	
		;--------------	
		; restore
		pop r15
		pop r14
		pop r13
		pop r12

		mov	rax,	EXIT_SUCCESS
		
		ret

;-----------------------------
;	void intro()
;
;		register usage:
intro:
	mov	rdi,	MSG_INTRO
	mov	rsi,	FD_STDOUT
	call	print_null_terminated_string
	call crlf

	ret

;-----------------------------
;	void crlf()
;
;		register usage:
crlf:


	ret

;-----------------------------
;	void goodbye()
;
;		register usage:
goodbye:
	mov	rdi,	MSG_GOODBYE
	mov	rsi,	FD_STDOUT
	call	print_null_terminated_string
	call crlf

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

		cmp byte [r12], 0		; check the character at the address referenced in the r12 register
		je strlen_loop_done	; if you have found a 0 (i.e., null), then the string is terminated 	

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
