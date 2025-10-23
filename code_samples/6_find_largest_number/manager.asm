; =============================================================================
; Program: Largest Number Finder
; File: manager.asm
; Description: Assembly function that coordinates all program operations.
;              Allocates stack space for integer array, calls input_array,
;              output_array, and find_largest functions, and manages program flow.
; Author: Generated for Assembly/C++ Hybrid Programming Exercise
; Platform: Ubuntu x86-64
; Assembler: YASM
; Calling Convention: System V AMD64 ABI
; =============================================================================

; Declare external C++ functions that will be called from this module
extern input_array          ; C++ function to get user input
extern printf              ; C library function for formatted output

; Declare external assembly functions
extern output_array        ; Assembly function to display the array
extern find_largest        ; Assembly function to find largest value's index

; Make the manager function visible to other modules (especially largest.cpp)
global manager

; =============================================================================
; Data Section - Read-only data
; =============================================================================
section .data

; Maximum number of integers that can be stored in the array
MAX_INTEGERS equ 100       ; Constant: array capacity limit

; String messages used by the manager function
; Note: All strings are null-terminated for C compatibility

msg_manager_start: db "The manager is here to assist you.", 10, 0
msg_no_integers: db "Error! No integers were entered, so no largest exists.", 10, 0
msg_display_intro: db "The following integers were received:", 10, 0
msg_largest_found: db "The largest value %ld has been found at index %ld", 10, 0
msg_return_to_driver: db "The manager will now return the count to the driver.", 10, 0

; =============================================================================
; BSS Section - Uninitialized data
; =============================================================================
section .bss
; No global variables needed - we use stack allocation as required

; =============================================================================
; Text Section - Code
; =============================================================================
section .text

; =============================================================================
; Function: manager
; Description: Main coordinator function that orchestrates the program flow.
;              Allocates local array on stack, manages function calls, and
;              handles program logic including error cases.
; 
; Parameters: None
; 
; Returns: Count of integers entered (in RAX)
; 
; Local Variables (on stack):
;   - Integer array: 100 qwords (800 bytes) - stores user input
;   - Count: 1 qword (8 bytes) - number of integers entered
; 
; Stack Frame Layout (from high to low addresses):
;   [rbp + 0]    : Saved RBP (previous base pointer)
;   [rbp - 8]    : Count of integers (local variable)
;   [rbp - 808]  : Array of 100 integers (800 bytes)
;   [rsp]        : Current stack pointer (may be lower due to alignment)
; 
; Registers Used:
;   RBP - Base pointer for stack frame
;   RSP - Stack pointer
;   RAX - Return value and temporary calculations
;   RDI - First argument to called functions
;   RSI - Second argument to called functions
;   RDX - Third argument to called functions
;   R12 - Preserved: stores count across function calls
;   R13 - Preserved: stores array pointer across function calls
; =============================================================================
manager:
    ; --- Function Prologue: Set up stack frame ---
    push rbp                   ; Save caller's base pointer
    mov rbp, rsp              ; Establish new base pointer for this frame
    
    ; Calculate total space needed on stack:
    ; - 800 bytes for array (100 integers × 8 bytes each)
    ; - 8 bytes for count variable
    ; - Extra bytes for 16-byte alignment if needed
    sub rsp, 808              ; Allocate 808 bytes for local variables
    
    ; Ensure stack is 16-byte aligned for function calls (System V ABI requirement)
    ; The stack pointer should be 16-byte aligned before any 'call' instruction
    and rsp, -16              ; Align RSP to 16-byte boundary (clear lower 4 bits)
    
    ; Save callee-saved registers that we'll use
    ; Per x86-64 ABI, we must preserve: RBX, R12-R15, RBP
    push r12                  ; Will hold count of integers
    push r13                  ; Will hold pointer to array
    
    ; --- Initialize Local Variables ---
    ; Calculate address of our local array on the stack
    ; Array starts at RBP - 808 (bottom of our allocated space)
    lea r13, [rbp - 808]      ; R13 = pointer to integer array
    
    ; Initialize count to 0
    mov qword [rbp - 8], 0    ; Store count = 0 in local variable
    
    ; --- Print Manager Welcome Message ---
    ; Use printf to display the manager's greeting
    mov rdi, msg_manager_start ; RDI = pointer to format string
    xor rax, rax              ; RAX = 0 (no vector registers used)
    call printf               ; Call C printf function
    
    ; --- Call input_array() to Get User Input ---
    ; Prepare arguments for input_array(array_ptr, max_count)
    ; System V ABI: RDI = 1st arg, RSI = 2nd arg
    mov rdi, r13              ; RDI = pointer to our array
    mov rsi, MAX_INTEGERS     ; RSI = maximum number of integers (100)
    call input_array          ; Call C++ input_array function
    
    ; Store the returned count
    ; input_array returns count in RAX
    mov r12, rax              ; R12 = count of integers entered
    mov [rbp - 8], r12        ; Also store in our local variable
    
    ; --- Check if Any Integers Were Entered ---
    ; If count is 0, we have an error condition
    cmp r12, 0                ; Compare count with 0
    je .no_integers_entered   ; Jump if count == 0
    
    ; --- Display the Array ---
    ; At least one integer was entered, so display them
    
    ; Print introductory message
    mov rdi, msg_display_intro ; RDI = pointer to format string
    xor rax, rax              ; RAX = 0 (no vector registers)
    call printf               ; Call printf
    
    ; Call output_array to display the integers
    ; Arguments: output_array(array_ptr, count)
    mov rdi, r13              ; RDI = pointer to array
    mov rsi, r12              ; RSI = count of integers
    call output_array         ; Call assembly output_array function
    
    ; --- Find the Largest Number ---
    ; Call find_largest to get the index of the maximum value
    ; Arguments: find_largest(array_ptr, count)
    mov rdi, r13              ; RDI = pointer to array
    mov rsi, r12              ; RSI = count of integers
    call find_largest         ; Call assembly find_largest function
    
    ; find_largest returns the index in RAX
    ; We need to print: "The largest value X has been found at index Y"
    ; We need to access array[index] to get the actual value
    
    ; Save the index temporarily
    mov r8, rax               ; R8 = index of largest value
    
    ; Calculate address of largest value: array_ptr + (index * 8)
    ; Since each integer is 8 bytes (qword), multiply index by 8
    mov rax, [r13 + r8 * 8]   ; RAX = array[index] (the largest value)
    
    ; Print the result message
    ; Format: "The largest value %ld has been found at index %ld"
    mov rdi, msg_largest_found ; RDI = format string
    mov rsi, rax              ; RSI = the largest value
    mov rdx, r8               ; RDX = the index
    xor rax, rax              ; RAX = 0 (no vector registers)
    call printf               ; Call printf
    
    ; Jump to the common exit point
    jmp .exit_manager
    
; --- Error Handler: No Integers Entered ---
.no_integers_entered:
    ; Print error message
    mov rdi, msg_no_integers  ; RDI = error message
    xor rax, rax              ; RAX = 0
    call printf               ; Call printf
    ; Count is already 0 in R12, so we'll return 0
    
; --- Common Exit Point ---
.exit_manager:
    ; Print message about returning to driver
    mov rdi, msg_return_to_driver ; RDI = message
    xor rax, rax              ; RAX = 0
    call printf               ; Call printf
    
    ; --- Function Epilogue: Clean Up and Return ---
    ; Prepare return value: count of integers entered
    mov rax, r12              ; RAX = count (return value)
    
    ; Restore callee-saved registers
    pop r13                   ; Restore R13
    pop r12                   ; Restore R12
    
    ; Restore stack pointer and base pointer
    mov rsp, rbp              ; Restore stack pointer
    pop rbp                   ; Restore caller's base pointer
    
    ; Return to caller (largest.cpp main function)
    ret                       ; Return with count in RAX
