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
; string constants

MSG_TEST                  db        "Hello world! This is the messenger library, ready to work.", 13, 10
MSG_TEST_LEN              equ       $-MSG_TEST

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

extern  print_message
extern print_newline
extern print_signed_int_64

main:

  mov rdi,  MSG_TEST
  mov rsi,  MSG_TEST_LEN
  call print_message

  call print_newline

  mov rdi,  DEBUG_INT
  call print_signed_int_64

  call print_newline

  mov rax,  SYS_EXIT
  mov rdi,  EXIT_SUCCESS
  syscall