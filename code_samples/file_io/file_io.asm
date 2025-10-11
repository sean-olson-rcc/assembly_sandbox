; ----------------------------------------------------------
; sample program demonstrating file i/o with system calls
; ----------------------------------------------------------


; ----------------------------------------------------------
; initialized-variable section
; ----------------------------------------------------------
section					.data

; ---------------------------
; c-strings
MSG_INTRO													db			"The File IO demo module has started", 0

MSG_FILE_OPEN_SUCCESS							db 			"Successfully opened read file: ", 0
MSG_FILE_OPEN_FAIL								db 			"Failed to open file: ", 0

MSG_FILE_CREATE_SUCCESS						db 			"Successfully created file: ", 0
MSG_FILE_CREATE_FAIL							db 			"Failed to create file: ", 0

MSG_FILE_COPY_DONE								db 			"Done copying files", 0

MSG_DIE_FILE_OPEN									db			"Terminating program after failure to open file", 0
MSG_DIE_FILE_CREATE								db			"Terminating program after failure to create file", 0

CRLF															db			13, 10, 0
CRLF_LEN													equ			$ -CRLF

; ---------------------------
; read-in buffer
COPY_BUFFER_LEN										equ			2

; ---------------------------
; file_names
FILE_NAME_TO_READ									db			"input.txt", 0
FILE_NAME_TO_WRITE								db			"output.txt", 0


; ---------------------------
; file-open flags
FILE_FLAGS_TO_READ										equ			0


; ---------------------------
; file-create flags												rw,r,0
FILE_PERMS_STANDARD								equ			00640q


; ---------------------------
; system calls
SYS_READ												equ			0
SYS_WRITE												equ			1
SYS_OPEN												equ			2
SYS_CREATE											equ			85
SYS_CLOSE												equ			3
SYS_EXIT												equ			60

; ---------------------------
; file descriptors
FD_STDOUT												equ			1
FD_STDERR												equ			2

; ---------------------------
; exit codes
EXIT_SUCCESS										equ			0
EXIT_FAIL												equ			1


; ----------------------------------------------------------
;  uninitialized-variable
; ----------------------------------------------------------
section					.bss



; ----------------------------------------------------------
;  text section
; ----------------------------------------------------------
section .text

global file_io

file_io:

	call welcome
	call file_tests

	; ---------------------------
	; exit with success -- uncomment if this is the main function; otherwise use `ret`
	; mov rax,	SYS_EXIT
	; mov	rdi, EXIT_SUCCESS 
	; syscall

	ret


; ---------------------------
; void welcome()
;
; register usage:
;		none
welcome:
	mov	rdi,	MSG_INTRO
	mov	rsi,	FD_STDOUT
	call print_null_terminated_string
	call print_newline
	ret

; ---------------------------
; void file_tests()
;
; register usage:
;		r12: input file handle
;		r13: output file handle
;		r14: count of bytes read from the input file
file_tests:

	; ------------
	; prologue
	push	r12	
	push	r13	
	push	r14

	; ------------
	; open the file to read
	mov	rdi,	FILE_NAME_TO_READ
	mov	rsi, FILE_FLAGS_TO_READ
	call open_file_read
	mov	r12,	rax

	; ------------
	; create file to write
	mov	rdi,	FILE_NAME_TO_WRITE
	mov	rsi, FILE_PERMS_STANDARD
	call create_file
	mov	r13,	rax

	; ------------
	; copy the input file to the output file
	mov	rdi,	r12
	mov	rsi,	r13
	call copy_file

	; ------------
	; print success message
	mov	rdi,	MSG_FILE_COPY_DONE
	mov	rsi,	FD_STDOUT
	call print_null_terminated_string
	call print_newline

	; ------------
	; close both files
	mov	rdi, r12
	call	close_file
	mov	rdi, r13
	call	close_file

	; ------------
	; epilogue
	pop r14
	pop r13
	pop r12

	ret

; ---------------------------
; long_FILE_HANDLE open_file_read(char * file_name, long flags)
;
; register usage:
;		r12: file name char*
;		r13: file flags
;		r14: file handle
open_file_read:

	; ------------
	; prologue
	push	r12	
	push	r13	
	push	r14

	; ------------
	; grab incoming arguments
	mov	r12,	rdi	
	mov	r13,	rsi

	; ------------
	; attempt to open file with syscall
	mov	rax,	SYS_OPEN
	mov	rdi,	r12
	mov	rsi,	r13
	syscall

	mov	r14,	rax
	; ------------
	; if successful, jump to success label
	cmp	r14,	0
	jge	open_file_read_success

	; ------------
	; local label: routine for failed file open
	open_file_read_fail:

		; ------------
		; print the fail message
		mov	rdi,	MSG_FILE_OPEN_FAIL
		mov	rsi, 	FD_STDERR
		call print_null_terminated_string

		mov	rdi,	r12
		mov	rsi, 	FD_STDERR
		call print_null_terminated_string
		call print_newline

		; ------------
		; call the die routine
		mov	rdi, MSG_DIE_FILE_OPEN
		call die

	; ------------
	; local label: routine for success file open
	open_file_read_success:

		; ------------
		; print the fail message
		mov	rdi,	MSG_FILE_OPEN_SUCCESS
		mov	rsi, 	FD_STDOUT
		call print_null_terminated_string

		mov	rdi,	r12
		mov	rsi, 	FD_STDOUT
		call print_null_terminated_string
		call print_newline

		; ------------
		; return file handle
		mov	rax, 	r14

	; ------------
	; epilogue
	pop r14
	pop r13
	pop r12

	ret

; ---------------------------
; long_FILE_HANDLE create_file(char * file_name, long flags)
;
; register usage:
;		r12: file name char*
;		r13: file flags
;		r14: file handle	
create_file:

	; ------------
	; prologue
	push	r12	
	push	r13	
	push	r14

	; ------------
	; grab incoming arguments
	mov	r12,	rdi	
	mov	r13,	rsi


	; ------------
	; epilogue
	pop r14
	pop r13
	pop r12

	ret	

; ---------------------------
; long_FILE_HANDLE copy_file(char * file_name, long flags)
;
; register usage:
;		r12: file name char*
;		r13: file flags
;		r14: file handle	
copy_file:

	; ------------
	; prologue
	push	r12	
	push	r13	
	push	r14

	; ------------
	; grab incoming arguments
	mov	r12,	rdi	
	mov	r13,	rsi


	; ------------
	; epilogue
	pop r14
	pop r13
	pop r12

	ret	

; ---------------------------
; void close_file(char * file_name)
;
; register usage:
;		r12: file handle
close_file:

	; ------------
	; prologue
	push	r12	

	; ------------
	; grab incoming arguments
	mov	r12,	rdi	

	mov	rax,	SYS_CLOSE
	mov rdi, 	r12
	syscall

	; ------------
	; epilogue
	pop r12
	ret			

; ---------------------------
; void print_null_terminated_string()
;
; register usage:
;		r12: c-string
;		r13: file handle 
;		r14: c-strings length
print_null_terminated_string: 

	; ------------
	; prologue
	push	r12	
	push	r13	
	push	r14

	; ------------
	; grab incoming arguments
	mov	r12,	rdi	
	mov	r13,	rsi

	; ------------
	; compute the string's length
	mov	rdi,	r12
	call	strlen
	mov	r14,	rax

	; ------------
	; use a syscall to print the string
	mov rax, 	SYS_WRITE
	mov	rdi,	r13  	
	mov	rsi,	r12  	
	mov	rdx,	r14  
	syscall	

	; ------------
	; epilogue
	pop r14
	pop r13
	pop r12

	ret

; ---------------------------
; void print_newline()
print_newline:
	mov rax, 	SYS_WRITE
	mov rdi,	FD_STDOUT
	mov	rsi,	CRLF
	mov	rdx,	CRLF_LEN
	syscall
	ret

; ---------------------------
; int strlen(str * c-string)
;
; register usage:
;		rax:	counter for string-length loop
strlen:

	; ------------
	; initialize counter to 0
    xor rax, rax 
    
	.loop:
    cmp byte [rdi + rax], 0 ; Compare current byte with null terminator
    je .done                ; If null terminator found, we're done
    inc rax                 ; Increment counter
    jmp .loop               ; Continue loop
    
	.done:
    ret                     ; Return with length in rax

; ---------------------------
; void die(char* message)
;
; register usage:
;		r12: char* message

die:

	; ------------
	; grab the incoming arguments
	mov r12, rdi

	; ------------
	; print the message to standard error
	mov rdi,	r12
	mov	rsi, 	FD_STDERR
	call print_null_terminated_string
	call print_newline


	; ------------
	; exit the program
	mov	rax,	SYS_EXIT
	mov	rdi,	EXIT_FAIL
	syscall		