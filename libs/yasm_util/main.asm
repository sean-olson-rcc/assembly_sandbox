;---------------------------------------
; title: main.asm
; description: development driver for the yasm_util library, compiled for ubuntu x86_64
; by: sean olson
;---------------------------------------

;---------------------------------------
; .data section
;---------------------------------------

section .data

;-------------------------
; c-strings

TEST_STRING                           db        "This is a test of the print_string() function on the messanger library. ",0
TEST_FLOAT_FORMAT                     db        "This is value, %.2f, represents Pi, rounded to two decimal places.",0

TEST_STRING_INPUT_TEMPLATE            db        "Please enter your name: ",0
TEST_STRING_OUTPUT_TEMPLATE           db        "Yes.  Your name is %s",0


TEST_INTEGER_INPUT_TEMPLATE           db        "Please enter your birth year: ",0
TEST_INTEGER_OUTPUT_TEMPLATE          db        "Were you really born in %ld?",0

;-------------------------
; INPUT_BUFFERS

TEST_STRING_INPUT_BUFFER              db        100


;-------------------------
; numeric constants
TEST_INT                              dq        42
TEST_FLOAT							              dq			  3.14159

TEST_BUFFER_MAX                       dq        100


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

extern print_cstring
extern print_cstring_template
extern print_newline
extern print_long
extern print_float
extern print_formatted_float
extern flush_output

extern get_string_input
extern get_int64_input

main:

  call test_print_functions
  call test_input_functions

  mov rax,  SYS_EXIT
  mov rdi,  EXIT_SUCCESS
  syscall

test_print_functions:

  ;----------
  ; call the print_cstring() utility, passing a null-terminated c-string argument
  mov rdi,  TEST_STRING
  call print_cstring
  call print_newline

  ;----------
  ; call the print_long() utility, passing a long integer argument
  mov rdi,  TEST_INT
  call print_long
  call print_newline


  ;----------
  ; call the print_float() utility, passing a float pointer argument
  mov rdi, TEST_FLOAT
  call print_float
  call print_newline

  ;----------
  ; call the print_formatted_float() utility, passing a c-string template and a 
  ; single float pointer argument
  mov rdi, TEST_FLOAT_FORMAT
  mov rsi, TEST_FLOAT
  call print_formatted_float
  call print_newline

  ret
  
test_input_functions: 

  ;----------
  ; prompt the user for a string input
  mov rdi,  TEST_STRING_INPUT_TEMPLATE
  call print_cstring
  call flush_output

  ;----------
  ; call the get_string_input() utility, passing a buffer pointer and max-length arguments
  mov rdi, TEST_STRING_INPUT_BUFFER
  mov rsi, TEST_BUFFER_MAX
  call get_string_input

  ;----------
  ; echo back the user's string input
  mov rdi, TEST_STRING_OUTPUT_TEMPLATE
  mov rsi, TEST_STRING_INPUT_BUFFER
  call print_cstring_template

  ;----------
  ; prompt the user for an integer input
  mov rdi,  TEST_INTEGER_INPUT_TEMPLATE
  call print_cstring
  call flush_output

  ;----------
  ; call the get_int64_input() utility, passing a pointer to a 64-bit interger
  mov rdi, TEST_INT
  call get_int64_input

  ;----------
  ; echo back the user's int64 input
  mov rdi, TEST_INTEGER_OUTPUT_TEMPLATE
  mov rsi, [TEST_INT]
  call print_cstring_template
  call print_newline

  ret