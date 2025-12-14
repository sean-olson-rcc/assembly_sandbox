;--------------------------------------
;	void fn()
;		register usage:
;			rbp: stack frame base pointer preserved
;			rsp: stack pointer used to adjust 16-byte stack alignment
;
fn:
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


	;--------------------------------------
	; epilogue
	;-------------------

	mov rsp, rbp	
	pop rbp

	ret