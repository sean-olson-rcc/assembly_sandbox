; ;-------------------------------------------------------------------------------------------------
; ; title: yasm_util.asm
; ; description: a simple library to use C functions in yasm x86_64 ubuntu
; ; by: sean olson
; ;-------------------------------------------------------------------------------------------------


; ;-------------------------------------------------------------------------------------------------
; ; .data section -- predefined variables which live on the heap
; ;-------------------------------------------------------------------------------------------------

section					.data

	; ---------------------------
	; c-strings

	CRLF														db 			13,10,0

	LONG_PRINT_TEMPLATE							db			"%ld",0
	FLOAT_PRINT_TEMPLATE						db			"%.5f",0

	LONG_INPUT_TEMPLATE							db			"%d",0

	; ---------------------------
	; system calls
	SYS_WRITE												equ			1

	; ---------------------------
	; file descriptors
	FD_STDIN												equ			0
	FD_STDOUT												equ			1
	FD_STDERROR											equ			2

; --------------------------------------------------------------------------------------------------------------------
;  text section
; --------------------------------------------------------------------------------------------------------------------
section .text

	global 	print_cstring
	global	print_cstring_template
	global 	print_newline
	global 	print_long
	global 	print_float
	global 	print_formatted_float
	global	flush_output

	global 	get_string_input
	global  get_int64_input

	extern 	printf
	extern 	fflush
	extern 	stdin
	extern 	fgets
	extern	scanf

; ----------------------------------------------------------
;  print functions
; ----------------------------------------------------------	

	; ---------------------------
	; void print_cstring(char * cstring)
	;
	;		register usage
	;			rbp:	the base pointer is preserved
	;			rsp: the stack pointer is moved to accomodate 16-byte alignment
	;			r10: holds the pointer to a c-string template
	;			r11: holds the pointer to the c-string template's argument

	print_cstring:		

		; ------------
		; preserve
		push rbp
		mov rbp, rsp

		; ------------
		; collect the argument	
		mov r10,	rdi
		mov r11,	rsi

		; ------------
		; adjust RSP to nearest 16-byte aligned address
		sub rsp, 16
		and	rsp, -16

		; ------------
		; set the arguments and make C-lib function call
		mov rdi,	r10	
		mov	rsi, 	r11
		call printf

		; ------------
		; restore
		mov rsp, rbp
		pop rbp

		ret

	; ---------------------------
	; void print_cstring_template(char * template, auto arg_1, auto arg_2, auto arg_3, auto arg_4)
	;
	;		register usage
	;			rbp:	the base pointer is preserved
	;			rsp: the stack pointer is moved to accomodate 16-byte alignment


	print_cstring_template:		

		; ------------
		; preserve
		push rbp
		mov rbp, rsp


		; ------------
		; adjust RSP to nearest 16-byte aligned address
		sub rsp, 16
		and	rsp, -16

		; ------------
		; the arguments on registers rdi, rsi, rdx, and rcx will pass through as the C-lib function is called
		; mov rdi,	r10	
		call printf

		; ------------
		; restore
		mov rsp, rbp
		pop rbp

		ret		

	; ---------------------------
	; void print_newline(void)
	print_newline:	
		
		; ------------
		; preserve - none
		
		; ------------
		; set the arguments and make the syscall			

		mov	rdi,	CRLF
		call print_cstring

		; ------------
		; restore - none

		ret

; ---------------------------
	; void print_long(long * value)
	;
	;		register usage
	;			rbp:	the base pointer is preserved
	;			rsp: the stack pointer is moved to accomodate 16-byte alignment
	print_long:

		; ------------
		; preserve
		push rbp
		mov rbp, rsp

		; ------------
		; collect the arguments	
		mov r10,	rdi

		; ------------
		; adjust RSP to nearest 16-byte aligned address
		sub rsp, 16
		and	rsp, -16

		; ------------
		; set the arguments and make C-lib function call
		mov	rdi, LONG_PRINT_TEMPLATE
		mov rsi,	[r10]	
		call printf

		; ------------
		; restore
		mov rsp, rbp
		pop rbp

		ret

; ---------------------------
	; void print_float(float * value)
	;
	;		register usage
	;			rbp:	the base pointer is preserved
	;			rsp: the stack pointer is moved to accomodate 16-byte alignment
	print_float:

		; ------------
		; preserve
		push rbp
		mov rbp, rsp

		; ------------
		; collect the argument	
		mov r10,	rdi

		; ------------
		; adjust RSP to nearest 16-byte aligned address
		sub rsp, 16
		and	rsp, -16

		; ------------
		; set the arguments and make C-lib function call
		mov	rdi, FLOAT_PRINT_TEMPLATE
		movq xmm0,	[r10]		
		call printf

		; ------------
		; restore
		mov rsp, rbp
		pop rbp

		ret		

	; ---------------------------
	; void print_formatted_float(char * formatted_c-string, float * value)
	;
	;		register usage
	;			rbp:	the base pointer is preserved
	;			rsp: the stack pointer is moved to accomodate 16-byte alignment
	print_formatted_float:

		; ------------
		; preserve
		push rbp
		mov rbp, rsp

		; ------------
		; collect the arguments	
		mov r10,	rdi
		mov	r11, 	rsi	

		; ------------
		; adjust RSP to nearest 16-byte aligned address
		sub rsp, 16
		and	rsp, -16

		; ------------
		; set the arguments and make C-lib function call
		mov	rdi, 	r10
		movq xmm0,	[r11]		
		call printf

		; ------------
		; restore
		mov rsp, rbp
		pop rbp

		ret		

	; ---------------------------
	; void flush_output()
	;
	;		register usage
	;			rbp:	the base pointer is preserved
	;			rsp: the stack pointer is moved to accomodate 16-byte alignment
	flush_output:
		; ------------
		; preserve
		push rbp
		mov rbp, rsp
			
		; ------------
		; adjust RSP to nearest 16-byte aligned address
		sub rsp, 16
		and	rsp, -16
			
		; ------------
		; flush the printr buffer the the terminal, passing null as the argument			
		xor rdi, rdi
		call fflush
			
		; ------------
		; restore
		mov rsp, rbp
		pop rbp

		ret	

; ----------------------------------------------------------
;  user input functions
; ----------------------------------------------------------			

	; ---------------------------
	; void get_string_input(buffer * cstring, long length)
	;
	;		register usage
	;			rbp:	the base pointer is preserved
	;			rsp: 	the stack pointer is moved to accomodate 16-byte alignment
	;			r10:	pointer to buffer's first character
	;			r11:	a long indicating the length of the buffer

	get_string_input:

		; ------------
		; preserve
		push rbp
		mov rbp, rsp

		; ------------
		; collect the arguments	
		mov r10,	rdi
		mov	r11, 	rsi	

		; ------------
		; adjust RSP to nearest 16-byte aligned address
		sub rsp, 16
		and	rsp, -16

		; ------------
		; set the arguments and make C-lib function call
		mov	rdi, 	r10
		mov	rsi,	r11
		mov	rdx,	[rel stdin]		
		call fgets

		; ------------
		; restore
		mov rsp, rbp
		pop rbp

		ret


	; ---------------------------
	; void get_int64_input(pointer * int)
	;
	;		register usage
	;			rbp:	the base pointer is preserved
	;			rsp: 	the stack pointer is moved to accomodate 16-byte alignment
	;			r10:	pointer to integer address

	get_int64_input:

		; ------------
		; preserve
		push rbp
		mov rbp, rsp

		; ------------
		; collect the arguments	
		mov r10,	rdi

		; ------------
		; adjust RSP to nearest 16-byte aligned address
		sub rsp, 16
		and	rsp, -16

		; ------------
		; set the arguments and make C-lib function call
		mov	rdi, 	LONG_INPUT_TEMPLATE
		mov	rsi,	r10
		call scanf

		; ------------
		; restore
		mov rsp, rbp
		pop rbp

		ret

			; ---------------------------
	; void get_float_input(buffer * cstring, long length)
	;
	;		register usage
	;			rbp:	the base pointer is preserved
	;			rsp: 	the stack pointer is moved to accomodate 16-byte alignment
	;			r10:	pointer to buffer's first character
	;			r11:	a long indicating the length of the buffer

	get_float_input:

		; ------------
		; preserve
		push rbp
		mov rbp, rsp

		; ------------
		; collect the arguments	
		mov r10,	rdi
		mov	r11, 	rsi	

		; ------------
		; adjust RSP to nearest 16-byte aligned address
		sub rsp, 16
		and	rsp, -16

		; ------------
		; set the arguments and make C-lib function call
		mov	rdi, 	r10
		mov	rsi,	r11
		mov	rdx,	[rel stdin]		
		call fgets

		; ------------
		; restore
		mov rsp, rbp
		pop rbp

		ret


