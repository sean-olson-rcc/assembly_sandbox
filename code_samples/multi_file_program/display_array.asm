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
		; loop through the array  
		display_array_loop:
			; ------------
			; jump out of loop if counter is equal to the length  
			cmp rbx, r13 
			je display_array_done  
			
			; ------------
			; assign the current value to the argument register and add to accumulator
			mov rdi, [r12 + rbx*8] 
			add	r14,	rdi

			; ------------
			; print out the 64-bit int with the lib function and the separator
			call libPuhfessorP_printSignedInteger64 
			call print_separator
			
			; ------------
			; increment the counter and go back to the beginning of the loop	
			inc rbx   
			jmp display_array_loop		


		display_array_done:
		; ------------
		; print goodbye	
    mov rdi, MSG_GOOD_BYE
    mov rsi, MSG_GOOD_BYE_LEN  
    call print_string
		call print_newline

		; ------------
		; restore and stack align
		pop r13
		pop r12	
		pop rbx
		pop rbp		

		ret
	print_separator:
		mov rax, 	SYS_WRITE
		mov rdi,	FD_STDOUT
		mov	rsi,	SEPARATOR
		mov	rdx,	2
		syscall
		ret