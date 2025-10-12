; ----------------------------------------------------------
; display_array.asm
; ----------------------------------------------------------


; ----------------------------------------------------------
; initialized-variable section
; ----------------------------------------------------------
section					.data

	; ---------------------------
	; strings
	MSG_GREET												db 			"In the display_array.asm code"
	MSG_GREET_LEN										equ			$-MSG_GREET


	MSG_GOOD_BYE										db 			"Leaving the display_array.asm code"
	MSG_GOOD_BYE_LEN								equ			$-MSG_GOOD_BYE	

	SEPARATOR												db			", "

	; ---------------------------
	; system calls
	SYS_WRITE												equ			1

	; ---------------------------
	; file descriptors
	FD_STDOUT												equ			1

	; ---------------------------
	; debug data
	INT_VALUE												dq			64

; ----------------------------------------------------------
;  text section
; ----------------------------------------------------------
section .text
	global display_array
	extern libPuhfessorP_printSignedInteger64
	extern print_string
	extern print_newline

	; ---------------------------
	; void display_array()
	;
	;	register usage:
	;		rbp: preserved and restored to manage stack alignment
	;		r12: hold the array pointer
	;		r13: hold the array length
	;		r8: holds the cumulative value of the array elements
	display_array:

		; ------------
		; preserve and stack align
		push rbp
		push rbx
		push r12	
		push r13

		; ------------
		; capture the arguments	
		mov	r12,	rdi
		mov r13,	rsi

		; ------------
		; zero-out the counters 
		xor rbx, rbx
		xor	r8, r8  

		; ------------
		; print greeting	
    mov rdi, MSG_GREET 
    mov rsi, MSG_GREET_LEN  
    call print_string
		call print_newline

		; ; ------------
		; ; print test value
		; mov	rdi, r13
		; call libPuhfessorP_printSignedInteger64
		; call print_newline

		; ------------
		; verify that the array is not empty
		cmp rbx, r13 
		je display_array_done  

		; ------------
		; loop through the array  
		display_array_loop:
			; ------------
			; jump out of loop if counter is equal to the length  
			cmp rbx, r13 
			; je display_array_done  
			
			; ------------
			; assign the current value to the argument register and add to accumulator
			mov rdi, [r12 + rbx*8] 
			add	r8,	rdi

			; ------------
			; print out the 64-bit int with the lib function and the separator
			call libPuhfessorP_printSignedInteger64 
			
			; ------------
			; increment the counter and go back to the beginning of the loop	
			inc rbx   
			cmp rbx, r13
			jl	print_separator		

		display_array_done:
		; ------------
		; set the return value
		mov rax, r8

		; ------------
		; restore and stack align
		pop r13
		pop r12	
		pop rbx
		pop rbp		

		ret

		; ---------------------------
		; void print_separator()
		;
		;	register usage: none
		print_separator:
			mov rax, 	SYS_WRITE
			mov rdi,	FD_STDOUT
			mov	rsi,	SEPARATOR
			mov	rdx,	2
			syscall
			jmp display_array_loop