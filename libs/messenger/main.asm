;---------------------------------------
; title: main.asm
; description: development driver for the messnger library, compiled for ubuntu x86_64
; by: sean olson
;---------------------------------------

;---------------------------------------
; .data section
;---------------------------------------

section .data

;-------------------------
; c-strings

MSG_PRINT_STRING_DEMO                 db        "This is a demo of the print_string() function on the messanger library", 13, 0


;-------------------------
; integer constants
DEBUG_INT                 dq     42


;-------------------------
; exit constants

EXIT_SUCCESS		          equ				0				; success code
SYS_EXIT				          equ				60			; terminate

;---------------------------------------
; .text section -- program instruction set
;---------------------------------------

section .text

;------------------------
; global exports and imports
; because this is a pure assembly program linking the 
; gcc libraries, it needs to have a entry point named main

global main

extern print_simple_string
extern print_newline
extern print_signed_int_64

main:

  mov rdi,  MSG_PRINT_STRING_DEMO
  call print_simple_string

  call print_newline
  call print_newline
  call print_newline
  call print_newline

  ; mov rdi,  DEBUG_INT
  ; call print_signed_int_64

  ; call print_newline

  mov rax,  SYS_EXIT
  mov rdi,  EXIT_SUCCESS
  syscall