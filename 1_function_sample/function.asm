; ======================================================================
; Assembly Program: Hello World with Function Sample
; Purpose: Demonstrates basic assembly programming concepts
; Platform: Linux x86_64 (uses Linux system calls)
; ======================================================================

; .data section - contains initialized data (read-write)
section       .data

; System call numbers for Linux x86_64
SYS_WRITE           equ   1      ; System call number for write()
SYS_EXIT            equ   60     ; System call number for exit()

; Exit status codes
EXIT_SUCCESS        equ   0      ; Standard success exit code

; File descriptors (standard I/O)
FD_STDIN            equ   0      ; Standard input file descriptor
FD_STDOUT           equ   1      ; Standard output file descriptor

; String data
; db = define byte(s) - stores the string in memory
; 13,10 = carriage return + line feed (CRLF - newline on many systems)
HELLO_STRING        db    "Hello, my name is Something Else.  What's yours?"

; Calculate string length at assembly time
; $ = current location counter, $-HELLO_STRING = length of string
HELLO_STRING_LEN     equ   $-HELLO_STRING


; Newline sequence (carriage return + line feed)
CRLF                db  13,10     ; 13=CR (\r), 10=LF (\n)
CRLF_LEN            equ $-CRLF     ; Calculate length (2 bytes)

; .bss section - contains uninitialized data (will be zeroed at runtime)
; This section is empty in this program but good practice to include
section .bss

; .text section - contains the executable code
section       .text

; Make _start symbol visible to the linker (entry point)
global _start

; Program entry point - where execution begins
_start:
  ; Main program execution begins here
  ; Set up arguments for print_message function
  mov rdi, HELLO_STRING         ; rdi = first argument (pointer to string)
  mov rsi, HELLO_STRING_LEN     ; rsi = second argument (string length)
  call print_message            ; Call our custom print function

  ; ===== EXIT SYSTEM CALL =====
  ; Prepare arguments for sys_exit(status)
  mov rax, SYS_EXIT         ; rax = system call number (60 = exit)
  mov rdi, EXIT_SUCCESS     ; rdi = exit status (0 = success)
  syscall                   ; Invoke system call - program terminates here 


; ======================================================================
; Function: print_message
; Purpose: Prints a string to stdout with newlines before and after
; Parameters: rdi = pointer to string, rsi = string length
; Returns: nothing
; Modifies: rax, rdi, rsi, rdx (via system calls)
; ======================================================================
print_message:

  ; Function prologue - save registers we'll use
  push r12                      ; Save r12 (callee-saved register)
  push r13                      ; Save r13 (callee-saved register)

  ; Store function parameters in preserved registers
  mov r12, rdi                  ; r12 = string pointer (preserve across calls)
  mov r13, rsi                  ; r13 = string length (preserve across calls)

  ; Print newline before the message
  call add_newline_space        ; Add spacing before message

  ; ===== WRITE SYSTEM CALL =====
  ; Prepare arguments for sys_write(fd, buf, count)
  mov rax, SYS_WRITE            ; rax = system call number (1 = write)
  mov rdi, FD_STDOUT            ; rdi = file descriptor (1 = stdout)
  mov rsi, r12                  ; rsi = buffer pointer (our string)
  mov rdx, r13                  ; rdx = byte count (string length)
  syscall                       ; Invoke system call to print string

  ; Print newline after the message
  call add_newline_space        ; Add spacing after message

  ; Function epilogue - restore registers
  pop r13                       ; Restore r13
  pop r12                       ; Restore r12

  ret                           ; Return to caller   

; ======================================================================
; Function: add_newline_space
; Purpose: Prints a carriage return + line feed (newline) to stdout
; Parameters: none
; Returns: nothing
; Modifies: rax, rdi, rsi, rdx (via system call)
; ======================================================================
add_newline_space:
  ; ===== WRITE SYSTEM CALL =====
  ; Prepare arguments for sys_write(fd, buf, count)
  mov rax, SYS_WRITE            ; rax = system call number (1 = write)
  mov rdi, FD_STDOUT            ; rdi = file descriptor (1 = stdout)
  mov rsi, CRLF                 ; rsi = buffer pointer (CRLF string)
  mov rdx, CRLF_LEN             ; rdx = byte count (2 bytes: CR+LF)
  syscall                       ; Invoke system call to print newline

  ret                           ; Return to caller  
