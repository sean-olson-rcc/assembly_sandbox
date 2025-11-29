# Makefile Templates for Assembly, C, and C++ Programs

A collection of standardized makefile templates for various project types on Ubuntu x86-64 systems using YASM assembler, GCC, and G++.

**Author:** Sean Olson  
**Date:** November 29, 2025  
**Source:** Derived from makefile developed and demonstrated by Professor Michael Peralta

---

## Overview

This directory contains seven makefile templates designed to handle different combinations of programming languages:

- Pure Assembly
- Pure C
- Pure C++
- Assembly with C Standard Library
- Hybrid C + Assembly
- Hybrid C++ + Assembly
- Hybrid C + C++ + Assembly

Each makefile follows consistent conventions and includes:
- Development and production build configurations
- Automatic dependency tracking (for C/C++)
- Integrated debugging support
- Clean build management
- Helpful menu system

---

## Available Templates

| Template | Filename | Description |
|----------|----------|-------------|
| Pure Assembly | `asm_pure\makefile` | Assembly only, no C runtime, links with `ld` |
| Assembly with C Lib | `asm_with_c_lib\makefile` | Assembly calling C functions (printf, etc.), links with `gcc` |
| Pure C | `c_pure\makefile` | C programs only, links with `gcc` |
| Pure C++ | `c++_pure\makefile` | C++ programs only, links with `g++` |
| Assembly C Hybrid | `asm_c_hybrid\makefile` | Hybrid C and assembly, links with `gcc` |
| Assembly, C++ Hybrid | `asm_C++hybrid\makefile` | Hybrid C++ and assembly, links with `g++` |
| Assembly, C, C++ Hybrid | `asm_c_C++hybrid\makefile` | All three languages, links with `g++` |

---

