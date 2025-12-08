;------------------------------------------------------------------------------
; title: 
; description:
; by: sean olson
; date:
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; data section for initialized variables
;------------------------------------------------------------------------------
section					.data

;--------------------
; c-strings
MSG_HELLO												db							"Hello, my name is Sean Olson",13,10,0

;--------------------
; integers
MY_LONG_INT											dq							98728176287632
MY_DWORD_INT										dd 							276276276

;--------------------
; system calls
SYS_READ												equ							0
SYS_WRITE												equ							1
SYS_OPEN												equ							2
SYS_CREATE											equ							85
SYS_CLOSE												equ							3
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
FD_STDERROR											equ							2

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


		mov	rax,	EXIT_SUCCESS
		mov rdi,	SYS_EXIT
		syscall