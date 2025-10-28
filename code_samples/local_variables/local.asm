;-------------------------------------
; local.asm
;-------------------------------------

;-------------------------------------
; data section:  for initialized variables
;-------------------------------------
section .data

;-------------------
; strings

MSG_INTRO               db      "Hello! I am Sean Olson, speaking to you from the local.asm code file.", 13, 10
MSG_INTRO_LEN           equ     $-MSG_INTRO

;-------------------
; note: printf won't flush unless the string contains a newline
PRINTF_LONG             db      "%lu", 13, 10, 0

CRLF                    db      13, 10
CRLF_LEN                equ     $-CRLF

;-------------------
; definitions

NUM_INTEGERS            equ     50
INTEGER_SIZE            equ     8
INTEGER_START_VALUE     equ     7

;-------------------
; syscalls

SYS_WRITE               equ     1


;-------------------
; file descriptors

FD_STDIN                equ     0
FD_STDOUT               equ     1
FD_STDERR               equ     2


;-------------------------------------
; text section
;-------------------------------------
section   .text

extern    printf

global local_vars
;-------------------
; void local_vars()
;-------------------
local_vars:

  call welcome

  call demo

  ret


;-------------------
; void welcome()
;-------------------
welcome:  
  mov rax, SYS_WRITE
  mov rdi, FD_STDOUT
  mov rsi, MSG_INTRO
  mov rdx, MSG_INTRO_LEN
  syscall

  ret



;-------------------
; void demo()
;
; register usage:
;   r12:  pointer to the first local integer
;   r13:  pointer to the last local integer
;   r14:  running pointer tothe current integer
;   r15:  temporary initialization value
;-------------------
demo:  

  ;---------
  ; preserve register state

  push  rbp
  push  r15
  push  r14
  push  r13
  push  r12

  ;---------
  ; preserve the stack pointer

  mov rbp,  rsp

  ;---------
  ; calculate the amount of stack space required for the integer array.

  mov r10, NUM_INTEGERS
  imul  r10, INTEGER_SIZE

  ;---------
  ; move the stack pointer downward to define space on the stack for the integer array.
  
  sub rsp, r10


  ;---------
  ; record the first and last stack address for the 

  mov r12,  rsp
  lea r13,  [r12 + ((NUM_INTEGERS - 1) * INTEGER_SIZE)]

  ;---------
  ; demo loop initialization

  demo_loop_init:

    ;---------
    ; initialize the moving pointer and the start value

    mov r14, r12
    mov r15,  INTEGER_START_VALUE
    
  ;---------
  ; demo loop top

  demo_loop_top:

    ;---------
    ; check for end of array

    cmp r14,  r13
    jg  demo_loop_done

    ;---------
    ; check for end of array

    mov [r14], r15
    inc r15

  ;---------
  ; demo loop bottom -- nothing needed it just functions as a marker

  demo_loop_bottom:

    ;---------
    ; advance to the next address in the array

    add r14, INTEGER_SIZE
    jmp demo_loop_top       

  ;---------
  ; demo loop done

  demo_loop_done:




  ;---------
  ; restore the stack pointer

  mov rsp,  rbp

  ;---------
  ; restore register statees
  pop   r12
  pop   r13
  pop   r14
  pop   r15
  pop   rbp

  ret




