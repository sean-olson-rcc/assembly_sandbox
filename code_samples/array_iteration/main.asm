section .data
    array db 1, 2, 3, 4, 5       ; Define an array of 5 integers
    array_len db 5                ; Length of the array
    sum db 0                      ; Variable to hold the sum
    msg db "Sum: ", 0             ; Message to display before the result
    result db 3 dup(0)            ; Buffer to hold the result in string format

section .text
    global _start                  ; Entry point for the program

_start:
    mov ecx, [array_len]          ; Load the length of the array into ecx
    xor ebx, ebx                  ; Clear ebx (this will hold the sum)
    xor esi, esi                  ; Initialize index (esi) to 0

iterate:
    cmp esi, ecx                   ; Compare index with the array length
    jge done                       ; If index >= length, jump to done

    mov al, [array + esi]          ; Load the current element into al
    add ebx, eax                   ; Add current element to the sum in ebx
    inc esi                        ; Increment the index
    jmp iterate                    ; Repeat the iteration

done:
    mov [sum], bl                  ; Store the sum into a variable (sum)

    ; Print the result
    mov eax, 4                     ; Syscall number for sys_write
    mov ebx, 1                     ; File descriptor 1 (stdout)
    mov ecx, msg                   ; Pointer to the message
    mov edx, 6                     ; Length of the message
    int 0x80                       ; Call the kernel

    ; Convert the sum to string and print
    mov eax, [sum]                 ; Load the sum into eax (byte)
    add eax, '0'                   ; Convert to ASCII character
    mov [result], al               ; Store character in result

    mov eax, 4                     ; Syscall number for sys_write
    mov ebx, 1                     ; File descriptor 1 (stdout)
    mov ecx, result                ; Pointer to the result
    mov edx, 1                     ; Length of the result
    int 0x80                       ; Call the kernel

    ; Exit the program
    mov eax, 1                     ; Syscall number for sys_exit
    xor ebx, ebx                   ; Return 0 status
    int 0x80                       ; Call the kernel