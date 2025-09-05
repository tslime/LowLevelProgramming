# Assembly Projects (NASM x86-64)

This repository is a growing collection of assembly language programs written in **NASM (Netwide Assembler)** for Linux x86-64.  
All programs use **raw Linux syscalls** for input/output (no C libraries) and demonstrate concepts in:

- Floating-point arithmetic  
- ASCII parsing and conversion  
- SIMD vectorization with SSE instructions  
- Low-level system interaction  

New programs will be added to this repository on a regular basis, expanding from basic arithmetic to advanced SIMD and algorithmic implementations.


## Programs

### 1. Floating-Point Calculator (`calc.asm`)

A command-line calculator that performs arithmetic (**addition, subtraction, multiplication, division**) on two floating-point numbers entered by the user.

#### Features
- Handles signed numbers (positive & negative).  
- Supports both integer and fractional input.  
- Manual **ASCII → floating-point parsing**.  
- Arithmetic executed with **SSE double-precision registers (`xmm`)**.  
- Converts results back to ASCII for display.  
- Precision controlled via a constant in `.data`.  

#### Example Run
```bash
$ ./calc
Enter your first number: 12.5
Enter your second number: -3.2
Press the number corresponding to the operation: 
  1.addition, 2.subtraction, 3.multiplication, 4.division: 1
The result of your arithmetic operation is: 9.3
