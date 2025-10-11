; array_demo.asm - Demonstrates iterating through an array
; This program sums all elements in an array of integers

global _start

section .data
    array dq 10, 20, 30, 40, 50    ; Array of 5 quadwords (64-bit integers)
    array_len equ 5                 ; Number of elements
    
section .bss
    result resq 1                   ; Reserve space for result

section .text

_start:
    xor rax, rax                    ; Clear rax (will hold our sum)
    xor rcx, rcx                    ; Clear rcx (our loop counter/index)
    
.loop:
    cmp rcx, array_len              ; Compare counter with array length
    je .done                        ; If equal, we've processed all elements
    
    add rax, [array + rcx*8]        ; Add current element to sum
                                    ; rcx*8 because each quadword is 8 bytes
    inc rcx                         ; Increment counter
    jmp .loop                       ; Continue loop
    
.done:
    mov [result], rax               ; Store result in memory
    
    ; Exit program
    mov rax, 60                     ; syscall: exit
    xor rdi, rdi                    ; exit code 0
    syscall