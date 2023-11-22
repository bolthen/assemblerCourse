.globl main

.text
main:
    mov $12, %rax
    xor %rdi, %rdi
    syscall

    lea 10(%rax), %rdi
    mov $12, %rax
    syscall

    mov $s, %rdi
    mov %rax, %rsi
    call printf

    ret

.data
s:
    .asciz "%d\n"
