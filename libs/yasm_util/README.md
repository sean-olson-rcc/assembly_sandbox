# YASM Utility Library (yasm_util.so)

A utility library for x86-64 YASM assembly programs on Ubuntu Linux. This library provides convenient wrapper functions around common C library I/O operations, making it easier to print formatted output and read user input from assembly programs.

## Overview

The `yasm_util.so` shared library wraps standard C library functions (`printf`, `scanf`, `fgets`, `fflush`) with proper stack alignment and calling conventions, allowing you to focus on your assembly logic rather than boilerplate setup code.

## Features

- **Print Functions**: Output strings, integers, floats with various formatting options
- **Input Functions**: Read strings and integers from user
- **Buffer Management**: Automatic output flushing for interactive prompts
- **Stack Safety**: All functions maintain 16-byte stack alignment required by System V AMD64 ABI


### Important Notes

1. **Entry Point**: When linking with `gcc`, your entry point must be named `main`, not `_start`.
2. **Stack Alignment**: The library handles stack alignment internally, but ensure your code maintains alignment before calling library functions.
3. **External Declarations**: Always declare library functions as extern before using them:

```
  extern print_cstring
  extern print_long
  extern get_string_input
```	

4. **Null Terminators**: String arguments to print_cstring must be null-terminated (ending with `0`).
5. **Buffer Sizes**: When using `get_string_input`, ensure your buffer is large enough and pass the correct size.
6. **Float Arguments**: Float printing functions expect pointers to 64-bit doubles, not the values themselves.
7. **Stack Safety**: Add this section to your assembly files to prevent executable stack warnings:

```
  section .note.GNU-stack noalloc noexec nowrite progbits
```

---

## API Reference

### Print Functions

#### `print_cstring`
Prints a null-terminated C-string to stdout.

**Signature:**
```asm
void print_cstring(char *cstring)
```

**Parameters:**
- `rdi`: Pointer to null-terminated string

---

#### `print_cstring_template`
Prints a formatted string with arguments (uses printf internally).

**Signature:**
```asm
void print_cstring_template(char *template, ...)
```

**Parameters:**
- `rdi`: Pointer to format string (printf-style)
- `rsi`, `rdx`, `rcx`, etc.: Arguments as required by format string


---

#### `print_newline`
Prints a carriage return and line feed (CRLF).

**Signature:**
```asm
void print_newline(void)
```

**Parameters:** None

---

#### `print_long`
Prints a 64-bit signed integer.

**Signature:**
```asm
void print_long(long *value)
```

**Parameters:**
- `rdi`: Pointer to 64-bit integer

---

#### `print_float`
Prints a 64-bit floating-point number with 5 decimal places.

**Signature:**
```asm
void print_float(double *value)
```

**Parameters:**
- `rdi`: Pointer to 64-bit float (double)

---

#### `print_formatted_float`
Prints a floating-point number with custom format string.

**Signature:**
```asm
void print_formatted_float(char *format, double *value)
```

**Parameters:**
- `rdi`: Pointer to format string (e.g., "%.2f")
- `rsi`: Pointer to 64-bit float


---

#### `flush_output`
Flushes the stdout buffer, forcing immediate display of buffered output. Essential for interactive prompts.

**Signature:**
```asm
void flush_output(void)
```

**Parameters:** None


---

### Input Functions

#### `get_string_input`
Reads a line of text from stdin into a buffer.

**Signature:**
```asm
void get_string_input(char *buffer, long max_length)
```

**Parameters:**
- `rdi`: Pointer to buffer
- `rsi`: Maximum number of characters to read (including null terminator)

**Returns:** The input string is stored in the buffer, including the newline character if present.

---

#### `get_int64_input`
Reads a 64-bit integer from stdin.

**Signature:**
```asm
void get_int64_input(long *destination)
```

**Parameters:**
- `rdi`: Pointer to 64-bit integer where result will be stored
---

## Troubleshooting

### Segmentation Faults

1. **Check stack alignment**: Ensure RSP is 16-byte aligned before calls
2. **Verify pointers**: Pass pointers to data, not values (except for print_cstring_template arguments)
3. **Null terminators**: Ensure strings end with 0

### Output Not Appearing

- Call `flush_output` after printing prompts without newlines
- Interactive input requires flushing the output buffer

### Linker Warnings

- Add `.note.GNU-stack` section to prevent executable stack warnings
- Ensure `-z noexecstack` is in linker flags

### Wrong Values Printed

- Check that you're passing pointers where required (print_long, print_float)
- Verify data types match function expectations (64-bit integers, doubles)

---


## License and Credits

**Author:** Sean Olson; the makefile taken from a pattern developed by Professor Michael Peralta

**Description:** A simple library to use C functions in YASM x86-64 Ubuntu

Feel free to use and modify this library for educational purposes.

