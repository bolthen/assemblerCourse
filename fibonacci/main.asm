.include "funcs.asm"

.text
.globl _start
_start:
    call readInt

    mov $0, %rbx
    mov $1, %rdx

    mov %rax, %rcx
p:
    mov %rdx, %rax
    add %rbx, %rax
    mov %rdx, %rbx
    mov %rax, %rdx

    loop p

    push %rax
    call writeInt

    mov $60, %rax
    syscall
