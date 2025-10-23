; =============================================================================
; Program: Largest Number Finder
; File: output_array.asm
; Description: Assembly function that displays an array of integers.
;              Prints the count followed by a comma-delimited list of values.
;              Ensures proper formatting with commas between elements.
; Author: Generated for Assembly/C++ Hybrid Programming Exercise
; Platform: Ubuntu x86-64
; Assembler: YASM
; Calling Convention: System V AMD64 ABI
; =============================================================================

; Declare external C library function
extern printf              ; C library function for formatted output

; Make this function visible to other modules
global output_array

; =============================================================================
; Data Section - Read-only data
; =============================================================================
section .data

; Format strings for printf
; %ld is the format specifier for a 64-bit signed integer

fmt_count: db "(%ld integers) ", 0      ; Format: "(N integers) "
fmt_first_int: db "%ld", 0               ; Format for first integer (no comma)
fmt_next_int: db ", %ld", 0              ; Format for subsequent integers (with comma)
fmt_newline: db 10, 0                    ; Newline character

; =============================================================================
; Text Section - Code
; =============================================================================
section .text

; =============================================================================
; Function: output_array
; Description: Displays an array of integers in a formatted manner.
;              Output format: "(N integers) val1, val2, val3, ..., valN\n"
;              Note: No comma before the first integer, but comma+space before
;              all subsequent integers.
; 
; Parameters (System V AMD64 ABI):
;   RDI - Pointer to the integer array (first parameter)
;   RSI - Count of integers in the array (second parameter)
; 
; Returns: Nothing (void function)
; 
; Registers Used:
;   RDI - First argument to printf (format string or data)
;   RSI - Second argument to printf (data)
;   RAX - Return value from printf, loop counter
;   R12 - Preserved: pointer to array
;   R13 - Preserved: count of integers
;   R14 - Preserved: current index in loop
; 
; Stack Frame: Minimal frame for alignment purposes
; =============================================================================
output_array:
    ; --- Function Prologue ---
    push rbp                   ; Save caller's base pointer
    mov rbp, rsp              ; Establish our base pointer
    
    ; Save callee-saved registers that we'll modify
    ; Per x86-64 ABI: must preserve RBX, R12-R15, RBP
    push r12                  ; Will hold array pointer
    push r13                  ; Will hold count
    push r14                  ; Will hold loop index
    
    ; Ensure stack is 16-byte aligned for function calls
    ; When we enter a function, RSP is 8 bytes off from 16-byte alignment
    ; (because the 'call' instruction pushed the return address)
    ; After pushing RBP, R12, R13, R14 (4 pushes × 8 bytes = 32 bytes),
    ; we need to check alignment
    and rsp, -16              ; Align stack to 16-byte boundary
    
    ; Save parameters in callee-saved registers
    ; This allows us to preserve them across function calls
    mov r12, rdi              ; R12 = pointer to array
    mov r13, rsi              ; R13 = count of integers
    
    ; --- Print the Count ---
    ; Display "(N integers) " where N is the count
    mov rdi, fmt_count        ; RDI = format string
    mov rsi, r13              ; RSI = count value
    xor rax, rax              ; RAX = 0 (no vector registers for printf)
    call printf               ; Call printf to display count
    
    ; --- Check if Count is Zero ---
    ; If count is 0, skip the array printing loop
    cmp r13, 0                ; Compare count with 0
    je .print_newline         ; If count == 0, just print newline and exit
    
    ; --- Print First Integer (No Comma) ---
    ; The first integer is printed without a preceding comma
    mov rdi, fmt_first_int    ; RDI = format string for first int (no comma)
    mov rsi, [r12]            ; RSI = array[0] (first element)
    xor rax, rax              ; RAX = 0
    call printf               ; Print the first integer
    
    ; --- Initialize Loop for Remaining Integers ---
    mov r14, 1                ; R14 = index (start at 1, since we printed array[0])
    
; --- Loop Through Remaining Integers ---
.print_loop:
    ; Check if we've printed all integers
    cmp r14, r13              ; Compare current index with count
    jge .print_newline        ; If index >= count, we're done
    
    ; Print current integer with comma+space prefix
    mov rdi, fmt_next_int     ; RDI = format string (", %ld")
    mov rsi, [r12 + r14 * 8]  ; RSI = array[index]
                              ; Address calculation: base + index * 8
                              ; (each integer is 8 bytes)
    xor rax, rax              ; RAX = 0
    call printf               ; Print the integer with comma
    
    ; Move to next integer
    inc r14                   ; index++
    jmp .print_loop           ; Continue loop
    
; --- Print Newline and Exit ---
.print_newline:
    ; Print a newline character to end the line
    mov rdi, fmt_newline      ; RDI = newline format string
    xor rax, rax              ; RAX = 0
    call printf               ; Print newline
    
    ; --- Function Epilogue ---
    ; Restore callee-saved registers
    pop r14                   ; Restore R14
    pop r13                   ; Restore R13
    pop r12                   ; Restore R12
    
    ; Restore stack and base pointer
    mov rsp, rbp              ; Restore stack pointer
    pop rbp                   ; Restore base pointer
    
    ; Return to caller
    ret                       ; Return (no value needed for void function)
