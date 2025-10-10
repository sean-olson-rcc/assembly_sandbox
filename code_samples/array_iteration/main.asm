section .data
    array db 1, 2, 3, 4, 5            ; Initialize an array of integers
    array_len db 5                     ; Length of the array
    msg db "The sum is: ", 0           ; Message to display
    result db 0                        ; Buffer to store the result

section .text
    global _start                      ; Entry point

_start:
    mov ecx, [array_len]              ; Load the length of the array into ecx
    xor ebx, ebx                      ; Clear ebx for accumulating the sum
    xor esi, esi                      ; Initialize index register esi to 0

iterate:
    cmp esi, ecx                      ; Compare current index against the length
    jge done                          ; If index >= length, jump to done
    
    mov al, [array + esi]            ; Load current array element into al
    add ebx, eax                      ; Add the current element to sum in ebx
    inc esi                          ; Increment the index
    jmp iterate                      ; Repeat iteration

done:
    ; Store the sum in result (convert from binary to ASCII)
    add ebx, '0'                     ; Convert to ASCII
    mov [result], bl                 ; Store the ASCII result

    ; Print the message
    mov eax, 4                       ; Syscall number for sys_write
    mov ebx, 1                       ; File descriptor (stdout)
    mov ecx, msg                     ; Message to print
    mov edx, 13                      ; Length of the message
    int 0x80                         ; Call kernel

    ; Print the sum
    mov eax, 4                       ; Syscall number for sys_write
    mov ebx, 1                       ; File descriptor (stdout)
    mov ecx, result                  ; Result to print
    mov edx, 1                       ; Length of the result
    int 0x80                         ; Call kernel

    ; Exit
    mov eax, 1                       ; Syscall number for sys_exit
    xor ebx, ebx                     ; Exit code 0
    int 0x80                         ; Call kernel
