; =============================================================================
; Program: Largest Number Finder
; File: find_largest.asm
; Description: Assembly function that finds the largest value in an array
;              and returns its index. Uses a simple linear search algorithm.
;              This function performs NO I/O operations.
; Author: Generated for Assembly/C++ Hybrid Programming Exercise
; Platform: Ubuntu x86-64
; Assembler: YASM
; Calling Convention: System V AMD64 ABI
; =============================================================================

; Make this function visible to other modules
global find_largest

; =============================================================================
; Text Section - Code
; =============================================================================
section .text

; =============================================================================
; Function: find_largest
; Description: Finds the index of the largest integer in an array.
;              Uses linear search to compare all elements and track the
;              index of the maximum value found.
;              IMPORTANT: This function does NOT perform any I/O.
; 
; Parameters (System V AMD64 ABI):
;   RDI - Pointer to the integer array (first parameter)
;   RSI - Count of integers in the array (second parameter)
; 
; Returns: 
;   RAX - Index of the largest value in the array (64-bit signed integer)
; 
; Algorithm:
;   1. Assume first element is the largest (index 0)
;   2. Loop through remaining elements (indices 1 to count-1)
;   3. If current element > largest so far, update largest and its index
;   4. Return the index of the largest element
; 
; Registers Used:
;   RDI - Pointer to array (preserved for address calculations)
;   RSI - Count of integers (preserved for loop limit)
;   RAX - Return value (index of largest)
;   RCX - Current index in loop
;   RDX - Value of current largest element
;   R8  - Value of current element being examined
; 
; Edge Cases:
;   - Count should always be >= 1 when this function is called
;   - If count is 1, returns 0 (only one element)
;   - If multiple elements have the same maximum value, returns index of first
; =============================================================================
find_largest:
    ; --- Function Prologue ---
    ; This is a leaf function (doesn't call other functions), so we have
    ; a minimal prologue. We don't need to set up a stack frame.
    push rbp                   ; Save base pointer (convention)
    mov rbp, rsp              ; Set up base pointer
    
    ; --- Initialize: Assume First Element is Largest ---
    ; Start by assuming array[0] is the largest value
    xor rax, rax              ; RAX = 0 (index of largest = 0)
    mov rdx, [rdi]            ; RDX = array[0] (value of largest so far)
    
    ; --- Check if Only One Element ---
    ; If count is 1, we're already done (return index 0)
    cmp rsi, 1                ; Compare count with 1
    jle .done                 ; If count <= 1, jump to done
    
    ; --- Initialize Loop ---
    mov rcx, 1                ; RCX = 1 (start loop at index 1)
                              ; We already examined array[0], so start at 1
    
; --- Main Loop: Search for Largest Value ---
; Loop invariant: 
;   - RAX contains index of largest value seen so far
;   - RDX contains the actual largest value seen so far
;   - RCX contains current index being examined
.search_loop:
    ; Check if we've examined all elements
    cmp rcx, rsi              ; Compare current index with count
    jge .done                 ; If index >= count, exit loop
    
    ; Load the current element into R8
    ; Address = base_pointer + (index * 8)
    ; Each integer is 8 bytes (qword), so multiply index by 8
    mov r8, [rdi + rcx * 8]   ; R8 = array[current_index]
    
    ; Compare current element with largest found so far
    cmp r8, rdx               ; Compare array[current] with largest_value
    jle .not_larger           ; If current <= largest, skip update
    
    ; --- New Largest Found ---
    ; Current element is larger than previous largest
    mov rdx, r8               ; Update largest value
    mov rax, rcx              ; Update index of largest
    
.not_larger:
    ; Move to next element
    inc rcx                   ; index++
    jmp .search_loop          ; Continue loop
    
; --- Function Exit ---
.done:
    ; RAX already contains the index of the largest element
    ; This is our return value per x86-64 calling convention
    
    ; --- Function Epilogue ---
    pop rbp                   ; Restore base pointer
    ret                       ; Return with index in RAX

; =============================================================================
; Algorithm Complexity: O(n) where n is the count of integers
; Space Complexity: O(1) - only uses registers, no additional memory
; 
; Example Walkthrough:
;   Array: [8, 7, 2, 10, 763, 33, 1]
;   Count: 7
;
;   Initial: index=0, largest_value=8
;   i=1: array[1]=7,   7 <= 8,   no change
;   i=2: array[2]=2,   2 <= 8,   no change
;   i=3: array[3]=10,  10 > 8,   UPDATE: index=3, largest=10
;   i=4: array[4]=763, 763 > 10, UPDATE: index=4, largest=763
;   i=5: array[5]=33,  33 <= 763, no change
;   i=6: array[6]=1,   1 <= 763,  no change
;   Return: index=4
; =============================================================================
