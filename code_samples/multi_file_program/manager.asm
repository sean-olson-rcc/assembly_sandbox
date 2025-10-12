;-----------------------------------------------------------
; the_asm_file.asm
; ----------------------------------------------------------


; ----------------------------------------------------------
; initialized-variable section
; ----------------------------------------------------------
section					.data

	; ---------------------------
	; strings
	MSG_GREET														db 			"In the_asm_file.asm"
	MSG_GREET_LEN												equ			$-MSG_GREET


	MSG_CALLING_DISPLAY_ARRAY						db 			"Calling display_array() in another assembly-code file."
	MSG_CALLING_DISPLAY_ARRAY_LEN				equ			$-MSG_CALLING_DISPLAY_ARRAY	

	MSG_RETURN_FROM_DISPLAY_ARRAY				db 			"Returned to manager.asm from calling display_array() function in another assembly-code file."
	MSG_RETURN_FROM_DISPLAY_ARRAY_LEN		equ			$-MSG_RETURN_FROM_DISPLAY_ARRAY

	MSG_CALLING_REVERSE_ARRAY						db 			"Calling reverse_array() a C++ file."
	MSG_CALLING_REVERSE_ARRAY_LEN				equ			$-MSG_CALLING_REVERSE_ARRAY	

	MSG_RETURN_FROM_REVERSE_ARRAY				db 			"Returned to manager.asm from calling reverse_array() function in a C++ code file."
	MSG_RETURN_FROM_REVERSE_ARRAY_LEN		equ			$-MSG_RETURN_FROM_REVERSE_ARRAY		

	MSG_GOOD_BYE												db 			"Leaving the_asm_file.asm.  Good bye!"
	MSG_GOOD_BYE_LEN										equ			$-MSG_GOOD_BYE

	; ---------------------------
	; system calls
	SYS_WRITE														equ			1

	; ---------------------------
	; file descriptors
	FD_STDOUT														equ			1

	; ---------------------------
	; debug data
	INT_VALUE														dq			100
	INT_ARRAY 													dq 			10, 20, 30, 40, 50 
	INT_ARRAY_LEN												equ			5	

; ----------------------------------------------------------
;  text section
; ----------------------------------------------------------
section .text
	global manager
	extern display_array
	extern reverse_array
	extern print_string
	extern print_newline	

	; ---------------------------
	; int manager()
	manager:

		; ------------
		; print greeting	
    mov rdi, MSG_GREET 
    mov rsi, MSG_GREET_LEN  
    call print_string
		call print_newline


		; ------------
		; display the array
		call display_array_routine


		; ------------
		; reverse the array
		call reverse_array_routine
	
		; ------------
		; print farewell	
    mov rdi, MSG_GOOD_BYE 
    mov rsi, MSG_GOOD_BYE_LEN  
    call print_string
		call print_newline		

		; ------------
		; set return value
		mov rax, [INT_VALUE]
		ret

	; ---------------------------
	; void display_array_routine()
	display_array_routine:

		; ------------
		; print status message before calling display_array()
		mov rdi, MSG_CALLING_DISPLAY_ARRAY
		mov rsi, MSG_CALLING_DISPLAY_ARRAY_LEN
		call print_string
		call print_newline

		; ------------
		; call the display_array function			
		mov rdi, INT_ARRAY
		mov	rsi, INT_ARRAY_LEN
		call display_array
		
		; ------------
		; print return status from display_array()
		mov rdi, MSG_RETURN_FROM_DISPLAY_ARRAY 
		mov rsi, MSG_RETURN_FROM_DISPLAY_ARRAY_LEN 
		call print_string
		call print_newline

		ret

	; ---------------------------
	; void reverse_array_routine()
	reverse_array_routine:

		; ------------
		; print status message before calling reverse_array()
    mov rdi, MSG_CALLING_REVERSE_ARRAY
    mov rsi, MSG_CALLING_REVERSE_ARRAY_LEN
    call print_string
		call print_newline

		; ------------
		; call the reverse array method in c++ file	
		mov	rdi,	INT_ARRAY
		mov	rsi,	INT_ARRAY_LEN
		call reverse_array

		; ------------
		; print return status from reverse_array()
    mov rdi, MSG_RETURN_FROM_REVERSE_ARRAY
    mov rsi, MSG_RETURN_FROM_REVERSE_ARRAY_LEN
    call print_string
		call print_newline	

		ret
