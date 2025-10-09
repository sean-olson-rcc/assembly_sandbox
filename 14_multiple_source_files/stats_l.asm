; ----------------------------------------------------------
; simple example void function
; ----------------------------------------------------------


; ----------------------------------------------------------
; data section
; ----------------------------------------------------------

section					.data


; ----------------------------------------------------------
; uninitialized variable section
; ----------------------------------------------------------

section					.bss


; ----------------------------------------------------------
; text section
; ----------------------------------------------------------

; function to find integer sum and integer average
; for a passed list of signed integers

; call:
;		stats(lst, len, &sum, &ave);

; arguments passed
;		1) rdi - address of array
;		2) rsi - length of passed array
;		3) rdx - address of variable sum
;		4) rcx - address of variable average

; returns:
;		sum of integers (via reference)
; 	average of integers (also via reference)


global stats
stats:

	;prologue
	push 	r12

	; find and return sum
	mov 	r11, 	0									; i=0
	mov 	r12d,	0									;	sum=0

sumLoop:

	mov			eax, 	dword [rdi+r11*4]	; get lst[i]
	add 		r12d,	eax								; update sum
	inc			r11											; i++
	cmp			r11,	rsi
	jb			sumLoop

	mov			dword [rdx],	r12d				; return sum 

	;epilogue
	pop 		r12	
	ret

