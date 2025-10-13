;-----------------------------------------------------------
; the_asm_file.asm
; ----------------------------------------------------------


; ----------------------------------------------------------
; initialized-variable section
; ----------------------------------------------------------
section					.data

	; ---------------------------
	; strings
	MSG_GREET														db 			"This program will reverse your array of integers."
	MSG_GREET_LEN												equ			$-MSG_GREET

	MSG_INPUT_INSTRUCTION								db 			"Enter a sequence of long integers separated by the enter key (one integer per line). Enter 'q' to quit."
	MSG_INPUT_INSTRUCTION_LEN						equ			$-MSG_INPUT_INSTRUCTION	

	MSG_INPUT_PROMPT										db 			"Enter the next integer: "
	MSG_INPUT_PROMPT_LEN								equ			$-MSG_INPUT_PROMPT	

	MSG_INPUT_FEEDBACK									db 			"You entered: "
	MSG_INPUT_FEEDBACK_LEN							equ			$-MSG_INPUT_FEEDBACK	

	MSG_INPUT_COMPLETE									db 			"You've entered nonsense. Assuming you are done!"
	MSG_INPUT_COMPLETE_LEN							equ			$-MSG_INPUT_COMPLETE	

	MSG_INPUT_REVIEW										db 			"These numbers were received and placed into the array:"
	MSG_INPUT_REVIEW_LEN								equ			$-MSG_INPUT_REVIEW	

	MSG_REVERSE_ARRAY_REVIEW						db 			"After the reverse function, these are the numbers of the array in their new order:"
	MSG_REVERSE_ARRAY_REVIEW_LEN				equ			$-MSG_REVERSE_ARRAY_REVIEW

	MSG_RESULT_REPORT_A									db			"You entered "
	MSG_RESULT_REPORT_A_LEN							equ			$-MSG_RESULT_REPORT_A

	MSG_RESULT_REPORT_B									db			"total numbers and their mean is "
	MSG_RESULT_REPORT_B_LEN							equ			$-MSG_RESULT_REPORT_B

	MSG_RESULT_REPORT_C									db			"."
	MSG_RESULT_REPORT_C_LEN							equ			$-MSG_RESULT_REPORT_C

	MSG_GOOD_BYE												db			"The mean will now be returned to the main function."
	MSG_GOOD_BYE_LEN										equ			$-MSG_GOOD_BYE

	; ; ---------------------------
	; ; system calls
	; SYS_WRITE														equ			1

	; ; ---------------------------
	; ; file descriptors
	; FD_STDOUT														equ			1

	; ---------------------------
	; debug data
	DEBUG_INT_VALUE														dq			100
	DEBUG_INT_ARRAY 													dq 			10, 20, 30, 40, 50 
	DEBUG_ INT_ARRAY_LEN											equ			5	

; ----------------------------------------------------------
; uninitialized-variable section
; ----------------------------------------------------------
section					.bss

	; ---------------------------
	; data definitions for the user input: 100 64-bit integers maximum
  INT_ARRAY       													resq 		100  
  INT_ARRAY_MAX   													equ  		100 

; ----------------------------------------------------------
;  text section
; ----------------------------------------------------------
section .text
	global manager
	extern display_array
	extern reverse_array
	extern print_string
	extern print_newline	
	extern libPuhfessorP_inputSignedInteger64
	extern libPuhfessorP_printSignedInteger64

	; ---------------------------
	; int manager()
	;
	;	register usage:
	;		r12: holds number of integers entered by the user
	manager:

		; ------------
		; display the intro and instructions
		call print_greeting
		call print_instruction	

		; ------------
		; get the user input
		call get_user_input
		mov r12, rax

		; ------------
		; display the array
		mov	rdi, INT_ARRAY
		mov	rsi, r12
		call display_array_routine

		; ------------
		; reverse the array
		call reverse_array_routine

		; ------------
		; print all of the fond farewells 
		call print_good_bye	

		; ------------
		; set return value
		mov rax, [DEBUG_INT_VALUE]
		ret

	; ---------------------------
	; void print_greeting(void)
	;
	; register usage: none
	print_greeting:
    mov rdi, MSG_GREET 
    mov rsi, MSG_GREET_LEN  
    call print_string
		call print_newline
		ret

	; ---------------------------
	; void print_instruction(void)
	;
	; register usage: none
	print_instruction:
		mov rdi, MSG_INPUT_INSTRUCTION
		mov rsi, MSG_INPUT_INSTRUCTION_LEN
		call print_string
		call print_newline
		ret			

	; ---------------------------
	; long_array get_input()
	;
	; register usage: 
	;		r12: hold a constant used to check for non-numeric inputs
	;		r14: is the input counter
	get_user_input:

    ; ------------
    ; preserve		
    push rbp
    push rbx
    push r12
    push r13
    push r14

    ; ------------
    ; zero out a counter to track the number of elements in the array
    xor r14, r14    ; r14 = 0 (element counter)
    
    ; ------------
    ; set the	
		mov r12, 0x8000000000000000		

    ; ------------
    ; begin the user input loop
    get_user_input_loop:

    		; ------------		
        ; call print_input_prompt
        call print_input_prompt

        ; call the extern function to capture user input
        call libPuhfessorP_inputSignedInteger64
        
    		; ------------					
        ; verify that the input was a number using the special value: 0x8000000000000000
        cmp rax, r12
        je input_complete
        
    		; ------------					
        ; if it is a valid number, append it to the array, store at array[r14]
        mov [INT_ARRAY + r14*8], rax 
        
    		; ------------					
        ; increment the counter
        inc r14
        
    		; ------------					
        ; call the print_input_feedback function, passing address of value just stored
        lea rdi, [INT_ARRAY + r14*8 - 8] 
        call print_input_feedback
        
    		; ------------					
        ; begin the input loop again
        jmp get_user_input_loop

				input_complete:
						; ------------	
						; call print_input_complete_message
						call print_input_complete_message
						
						; ------------							
						; set return value (number of elements entered)
						mov rax, r14

    ; ------------
    ; restore
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp

    ret

	; ---------------------------
	; void print_input_prompt(void)
	;
	; register usage: none
	print_input_prompt:
		mov rdi, MSG_INPUT_PROMPT
		mov rsi, MSG_INPUT_PROMPT_LEN
		call print_string
		call print_newline
		ret		

	; ---------------------------
	; void print_input_prompt(void)
	;
	; register usage: none
	print_input_feedback:

		; ------------
		; preserve and stack align
		push rbp
		push rbx
		push r12	
		push r13

		; ------------
		; capture the arguments	
		mov	r12,	rdi

		; ------------
		; print feedback text	
		mov rdi, MSG_INPUT_FEEDBACK
		mov rsi, MSG_INPUT_FEEDBACK_LEN
		call print_string		

		; ------------
		; assign the current value to the argument register
		mov rdi, [r12] 

		; ------------
		; print out the 64-bit int with the lib function and the separator
		call libPuhfessorP_printSignedInteger64 		

		; ------------
		; restore and stack align
		pop r13
		pop r12	
		pop rbx
		pop rbp	

		call print_newline

		ret		


	; ---------------------------
	; void print_input_complete_message(void)
	;
	; register usage: none
	print_input_complete_message:
		mov rdi, MSG_INPUT_COMPLETE
		mov rsi, MSG_INPUT_COMPLETE_LEN
		call print_string
		call print_newline
		ret				

	; ---------------------------
	; void display_array_routine(int64 * arr, int64 length)
	;
	;	register usage:
	;		r12: holds the array pointer
	;		r13: holds the array length
	display_array_routine:

		; ------------
		; preserve
		push r12
		push r13		

		; ------------
		; capture arguments
		mov	r12,	rdi
		mov	r13, 	rsi		

		; ------------
		; print return status from display_array()
		mov rdi, MSG_INPUT_REVIEW 
		mov rsi, MSG_INPUT_REVIEW_LEN 
		call print_string
		call print_newline

		; ------------
		; call the display_array function			
		mov rdi, r12
		mov	rsi, r13
		call display_array

		; ------------
		; print a blank line after the array		
		call print_newline
		call print_newline

		; ------------
		; restore
		pop r13
		pop r12	
		
		ret

	; void reverse_array_routine(int64 * arr, int64 length)
	;
	;	register usage:
	;		r12: holds the array pointer
	;		r13: holds the array length
	reverse_array_routine:

		; ------------
		; preserve
		push r12
		push r13		

		; ------------
		; capture arguments
		mov	r12,	rdi
		mov	r13, 	rsi		

		; ------------
		; print status message before calling reverse_array()
    mov rdi, MSG_REVERSE_ARRAY_REVIEW
    mov rsi, MSG_REVERSE_ARRAY_REVIEW_LEN
    call print_string
		call print_newline

		; ------------
		; call the reverse array method in c++ file	
		mov	rdi,	r12
		mov	rsi,	r13
		call reverse_array

		; ------------
		; call the display_array function			
		mov	rdi,	r12
		mov	rsi,	r13
		call display_array
		
		; ------------
		; print a blank line after the array		
		call print_newline
		call print_newline

		; ------------
		; restore
		pop r13
		pop r12			

		ret

	; ---------------------------
	; void print_instruction(void)
	;
	; register usage: none
	print_good_bye:
		mov rdi, MSG_RESULT_REPORT_A
		mov rsi, MSG_RESULT_REPORT_A_LEN
		call print_string
		call print_newline

		mov rdi, MSG_GOOD_BYE
		mov rsi, MSG_GOOD_BYE_LEN
		call print_string
		call print_newline		
		ret			
