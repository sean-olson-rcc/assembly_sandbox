;---------------------------------------
; title: math.asm
; date: 11/18/2025
; by: transcribed by Sean Olson from a video lesson by Professor Paul Peralta
;---------------------------------------

;---------------------------------------
; indicate that executable stack is NOT needed
;---------------------------------------
section .note.GNU-stack 
	noalloc 
	noexec 
	nowrite 
	progbits

;---------------------------------------
; data section for initialized variables
;---------------------------------------

section .data

;-------------------
; strings

MSG_MULT_IMMEDIATE_PREFIX								db				"The result of multiplying immediates is: ***"
MSG_MULT_IMMEDIATE_PREFIX_LEN						equ				$-MSG_MULT_IMMEDIATE_PREFIX

MSG_MULT_IMMEDIATE_SUFFIX								db				"***"
MSG_MULT_IMMEDIATE_SUFFIX_LEN						equ				$-MSG_MULT_IMMEDIATE_SUFFIX

MSG_MULT_GOLBAL_PREFIX									db				"The result of multiplying globals is: ***"
MSG_MULT_GOLBAL_PREFIX_LEN							equ				$-MSG_MULT_GOLBAL_PREFIX

MSG_MULT_GLOBAL_SUFFIX									db				"***"
MSG_MULT_GLOBAL_SUFFIX_LEN							equ				$-MSG_MULT_GLOBAL_SUFFIX

CRLF																		db				13,10
CRLF_LEN																equ				$-CRLF

;-------------------
; ssystem calls

SYS_WRITE																equ				1


;-------------------
; file descriptors

FD_STDOUT																equ				1

;-------------------
; return values

RETURN_VALUE														equ				7

;-------------------
; integers

MY_INT_A																equ				233
MY_INT_B																equ				256

;---------------------------------------
; text section for instructions
;---------------------------------------

section .text

global math

math:



	ret