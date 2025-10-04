# x86-64 Register Usage Reference

## 64-bit General Purpose Registers (x86-64)

| Register | Usage |
|----------|-------|
| RAX | Accumulator; Return value; Used for arithmetic operations |
| RBX | Base register; Callee-saved (preserved by function calls) |
| RCX | Counter register; Used for loop counters; 4th function argument |
| RDX | Data register; Used for I/O operations; 3rd function argument |
| RSI | Source index; Used for string operations; 2nd function argument |


| RDI | Destination index; Used for string operations; 1st function argument |
| RBP | Base pointer; Frame pointer for stack frames; Callee-saved |
| RSP | Stack pointer; Points to top of stack; Automatically managed |
| R8  | 5th function argument; Caller-saved |
| R9  | 6th function argument; Caller-saved |
| R10 | Temporary register; Caller-saved |
| R11 | Temporary register; Caller-saved |
| R12 | General purpose; Callee-saved |
| R13 | General purpose; Callee-saved |
| R14 | General purpose; Callee-saved |
| R15 | General purpose; Callee-saved |

## 32-bit General Purpose Registers (x86)

| Register | Usage |
|----------|-------|
| EAX | Accumulator; Return value; Lower 32 bits of RAX |
| EBX | Base register; Callee-saved; Lower 32 bits of RBX |
| ECX | Counter register; Loop counter; Lower 32 bits of RCX |
| EDX | Data register; I/O operations; Lower 32 bits of RDX |
| ESI | Source index; String operations; Lower 32 bits of RSI |
| EDI | Destination index; String operations; Lower 32 bits of RDI |
| EBP | Base pointer; Frame pointer; Lower 32 bits of RBP |
| ESP | Stack pointer; Points to stack top; Lower 32 bits of RSP |
| R8D | Lower 32 bits of R8 |
| R9D | Lower 32 bits of R9 |
| R10D | Lower 32 bits of R10 |
| R11D | Lower 32 bits of R11 |
| R12D | Lower 32 bits of R12 |
| R13D | Lower 32 bits of R13 |
| R14D | Lower 32 bits of R14 |
| R15D | Lower 32 bits of R15 |

## 16-bit General Purpose Registers

| Register | Usage |
|----------|-------|
| AX | Accumulator; Lower 16 bits of EAX/RAX |
| BX | Base register; Lower 16 bits of EBX/RBX |
| CX | Counter register; Lower 16 bits of ECX/RCX |
| DX | Data register; Lower 16 bits of EDX/RDX |
| SI | Source index; Lower 16 bits of ESI/RSI |
| DI | Destination index; Lower 16 bits of EDI/RDI |
| BP | Base pointer; Lower 16 bits of EBP/RBP |
| SP | Stack pointer; Lower 16 bits of ESP/RSP |
| R8W | Lower 16 bits of R8 |
| R9W | Lower 16 bits of R9 |
| R10W | Lower 16 bits of R10 |
| R11W | Lower 16 bits of R11 |
| R12W | Lower 16 bits of R12 |
| R13W | Lower 16 bits of R13 |
| R14W | Lower 16 bits of R14 |
| R15W | Lower 16 bits of R15 |

## 8-bit Registers

| Register | Usage |
|----------|-------|
| AL | Lower 8 bits of AX (bits 0-7) |
| AH | Upper 8 bits of AX (bits 8-15) |
| BL | Lower 8 bits of BX (bits 0-7) |
| BH | Upper 8 bits of BX (bits 8-15) |
| CL | Lower 8 bits of CX (bits 0-7) |
| CH | Upper 8 bits of CX (bits 8-15) |
| DL | Lower 8 bits of DX (bits 0-7) |
| DH | Upper 8 bits of DX (bits 8-15) |
| SIL | Lower 8 bits of SI (64-bit mode only) |
| DIL | Lower 8 bits of DI (64-bit mode only) |
| BPL | Lower 8 bits of BP (64-bit mode only) |
| SPL | Lower 8 bits of SP (64-bit mode only) |
| R8B | Lower 8 bits of R8 |
| R9B | Lower 8 bits of R9 |
| R10B | Lower 8 bits of R10 |
| R11B | Lower 8 bits of R11 |
| R12B | Lower 8 bits of R12 |
| R13B | Lower 8 bits of R13 |
| R14B | Lower 8 bits of R14 |
| R15B | Lower 8 bits of R15 |

## Segment Registers

| Register | Usage |
|----------|-------|
| CS | Code Segment; Points to code segment |
| DS | Data Segment; Points to data segment |
| ES | Extra Segment; Additional data segment |
| FS | Additional segment register; Often used for thread-local storage |
| GS | Additional segment register; Often used for thread-local storage |
| SS | Stack Segment; Points to stack segment |

## Index and Pointer Registers (16-bit addressing)

| Register | Usage |
|----------|-------|
| IP | Instruction Pointer; Points to next instruction (16-bit) |
| EIP | Extended Instruction Pointer; 32-bit instruction pointer |
| RIP | 64-bit Instruction Pointer; Points to next instruction |

## Flags Register

| Register | Usage |
|----------|-------|
| FLAGS | 16-bit flags register |
| EFLAGS | 32-bit extended flags register |
| RFLAGS | 64-bit flags register; Contains condition codes and control flags |

## Calling Convention Notes

**System V AMD64 ABI (Linux/Unix):**
- Function arguments: RDI, RSI, RDX, RCX, R8, R9 (then stack)
- Return value: RAX
- Callee-saved: RBX, RSP, RBP, R12-R15
- Caller-saved: RAX, RCX, RDX, RSI, RDI, R8-R11

**Microsoft x64 Calling Convention (Windows):**
- Function arguments: RCX, RDX, R8, R9 (then stack)
- Return value: RAX
- Callee-saved: RBX, RBP, RDI, RSI, RSP, R12-R15
- Caller-saved: RAX, RCX, RDX, R8-R11