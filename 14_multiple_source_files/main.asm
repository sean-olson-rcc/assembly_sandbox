; ----------------------------------------------------------
; simple example to call an external function
; ----------------------------------------------------------

; ----------------------------------------------------------
; data section
; ----------------------------------------------------------
section					.data

; -------------------------------
; standard constants
; -------------------------------

LF							equ				10			; line feed
NULL						equ				0				; end of string

TRUE						equ				1
FALSE						equ				0


EXIT_SUCCESS		equ				0				; success code
SYS_EXIT				equ				60			; terminate

; -------------------------------
; data declarations
; -------------------------------
section					.bss

lst1						dd				1, -2, 3, -4, 5, 
								dd				7, 9, 11
len1						dd				8

lst2						dd				2, -3, 4, -5, 6, 
								dd				-7, 10, 12, 14, 16
len2						dd				10


; ----------------------------------------------------------
; uninitialized variable section
; ----------------------------------------------------------
section 				.bss

sum1						resd				1
ave1						resd				1

sum2						resd				1
ave2						resd				1


extern	stats

; ----------------------------------------------------------
; text section
; ----------------------------------------------------------

global _start
_start:


; call the function
; HLL Call: stats(1st, len, &sum, &ave)

mov		rdi, lst1									; data set 1
mov		esi, dword [len1]					

mov		rdx, sum1
mov		rcx, ave1

call 	stats


mov		rdi, lst2									; data set 2
mov		esi, dword [len2]

mov		rdx, sum2
mov		rcx, ave2

call 	stats

; ----------------------------------------------------------
; example program done
; ----------------------------------------------------------
exampleDone:

mov 	rax, SYS_EXIT
mov		rdi, EXIT_SUCCESS
syscall