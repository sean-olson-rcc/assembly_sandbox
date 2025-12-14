;------------------------------------------------------------------------------
; title: stdin_out_err.asm
; description: a simple program in assembly demoing the use of the three file descriptor pipes
; by: sean olson
; date:12/14/2025
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; data section for initialized variables
;------------------------------------------------------------------------------
section					.data

;--------------------
; c-strings
MSG_INTRO												db							"The STDIN / STDOUT / STDERR demo module has started",13,10,0

MSG_BEGIN_STDOUT_STDERR					db							"Begin printing messages to STDOUT and STDERR ...",13,10,0
MSG_STDOUT											db							"This message will be printed to STDOUT (FD 1)",13,10,0
MSG_STDERR											db							"This message will be printed to STDERR (FD 2) ... Oh no!",13,10,0

MSG_BEGIN_STDIN									db							"We have detected the following STDIN: ",13,10,"*** BEGIN ***",13,10,0
MSG_END_STDIN										db							"*** END ***",13,10,0

MSG_GOODBYE											db							"Program now exiting,  Goodbye!",13,10,0
CRLF														db							13,10,0

;--------------------
; numbers
BUFFER_SIZE											equ							8192

;--------------------
; system calls
SYS_READ												equ							0
SYS_WRITE												equ							1
SYS_EXIT												equ							60

; ---------------------------
; file-open flags
FILE_FLAGS_TO_READ							equ							0

; ---------------------------
; file-create flags															rw,r,0
FILE_PERMS_STANDARD							equ							00640q

;--------------------
; file descriptors
FD_STDIN												equ							0
FD_STDOUT												equ							1
FD_STDERR												equ							2

;--------------------
; exit codes
EXIT_SUCCESS										equ							0
EXIT_FAIL												equ							1

;------------------------------------------------------------------------------
;  uninitialized-variable
;------------------------------------------------------------------------------
section					.bss


;------------------------------------------------------------------------------
;  text section
;------------------------------------------------------------------------------
section .text

global _start

_start:

		call intro
		call crlf
		call stdout_err
		call stdin

		mov	rdi,	EXIT_SUCCESS
		mov rax,	SYS_EXIT
		syscall

;--------------------------------------
;	void stdout_err()
;		register usage:
;			rbp: stack frame base pointer preserved
;			rsp: stack pointer used to adjust 16-byte stack alignment
;
stdout_err:
	;--------------------------------------
	; prologue
	;-------------------
	push rbp
	mov rbp, rsp

	;-------------------
	; set 16-byte stack alignment
	sub rsp, 16
	and rsp, -16

	;--------------------------------------
	; instructions
	;-------------------
	; announce the roadmap
	mov	rdi, MSG_BEGIN_STDOUT_STDERR
	mov rsi, FD_STDOUT
	call print_null_terminated_string
	call crlf

	;-------------------
	; print message to stdout
	mov	rdi, MSG_STDOUT
	mov rsi, FD_STDOUT
	call print_null_terminated_string
	call crlf

	;-------------------
	; print message to stderr
	mov	rdi, MSG_STDERR
	mov rsi, FD_STDERR
	call print_null_terminated_string
	call crlf


	;--------------------------------------
	; epilogue
	;-------------------

	mov rsp, rbp	
	pop rbp

	ret


;--------------------------------------
;	void stdin()
;		register usage:
;			rbp: stack frame base pointer preserved
;			rsp: stack pointer used to adjust 16-byte stack alignment
;			r12: 
;
stdin:
	;--------------------------------------
	; prologue
	;-------------------
	push rbp
	mov rbp, rsp
	push r12

	;-------------------
	; set 16-byte stack alignment
	sub rsp, 16
	and rsp, -16

	;--------------------------------------
	; instructions
	;-------------------
	; create a buffer on the stack
	sub rsp, BUFFER_SIZE
	mov r12, rbp

	;-------------------
	; print message to stdout
	mov	rdi, MSG_BEGIN_STDIN
	mov rsi, FD_STDOUT
	call print_null_terminated_string

	;-------------------
	; read from stdin
	mov	rax, SYS_READ
	mov rdi, FD_STDIN
	mov rsi, r12
	mov	rdx, BUFFER_SIZE
	syscall

	;-------------------
	; print what was read from stdin
	mov rdi, r12
	mov rsi, FD_STDOUT
	call print_null_terminated_string

	;-------------------
	; say goodbye
	mov	rdi, MSG_END_STDIN
	mov rsi, FD_STDOUT
	call print_null_terminated_string


	;--------------------------------------
	; epilogue
	;-------------------
	pop r12
	mov rsp, rbp	
	pop rbp

	ret	

;--------------------------------------
;	void intro()
;		register usage:
;			rbp: stack frame base pointer preserved
;			rsp: stack pointer used to adjust 16-byte stack alignment
;
intro:
	;--------------------------------------
	; prologue
	;-------------------
	push rbp
	mov rbp, rsp

	;--------------------------------------
	; instructions
	;-------------------
	mov rdi, MSG_INTRO
	mov rsi, FD_STDOUT
	call print_null_terminated_string
	call crlf

	;-------------------
	; set 16-byte stack alignment
	sub rsp, 16
	and rsp, -16



	;--------------------------------------
	; epilogue
	;-------------------
	mov rsp, rbp	
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

;--------------------------------------
;	void crlf()
;		register usage:
;			rbp: stack frame base pointer preserved
;			rsp: stack pointer used to adjust 16-byte stack alignment
;
crlf:
	;-------------------
	; prologue
	push rbp
	mov rbp, rsp

	;-------------------
	; set 16-byte stack alignment
	sub rsp, 16
	and rsp, -16

	mov rdi, MSG_INTRO
	mov rsi, CRLF
	call print_null_terminated_string

	;-------------------
	; epilogue

	mov rsp, rbp	
	pop rbp

	ret
	
;------------------------------------------------------------------------------
; note.GNU-stack section closes security holes
;------------------------------------------------------------------------------
section .note.GNU-stack noalloc noexec nowrite progbits		