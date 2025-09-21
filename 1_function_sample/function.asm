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
HELLO_STRING        db    "Hello, my name is Something Else",13,10

; Calculate string length at assembly time
; $ = current location counter, $-HELLO_STRING = length of string
HELLO_STRING_LEN     equ   $-HELLO_STRING

; .bss section - contains uninitialized data (will be zeroed at runtime)
; This section is empty in this program but good practice to include
section .bss

; .text section - contains the executable code
section       .text

; Make _start symbol visible to the linker (entry point)
global _start

; Program entry point - where execution begins
_start:

  ; ===== WRITE SYSTEM CALL =====
  ; Prepare arguments for sys_write(fd, buffer, count)
  mov rax, SYS_WRITE        ; rax = system call number (1 = write)
  mov rdi, FD_STDOUT        ; rdi = file descriptor (1 = stdout)
  mov rsi, HELLO_STRING     ; rsi = pointer to string buffer
  mov rdx, HELLO_STRING_LEN ; rdx = number of bytes to write
  syscall                   ; Invoke system call

  ; ===== EXIT SYSTEM CALL =====
  ; Prepare arguments for sys_exit(status)
  mov rax, SYS_EXIT         ; rax = system call number (60 = exit)
  MOV rdi, EXIT_SUCCESS     ; rdi = exit status (0 = success)
  syscall                   ; Invoke system call - program terminates here 
