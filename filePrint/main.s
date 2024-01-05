.globl _start
.text
_start:
    add $16, %rsp
    pop %rdi

    mov $2, %rax
    xor %rsi, %rsi
    syscall

    push %rax

    read:
        mov $0, %rax
        mov (%rsp), %rdi
        mov $s, %rsi
        mov $4096, %rdx
        syscall

        push %rax

        mov $1, %rax
        mov $1, %rdi
        mov $s, %rsi
        mov (%rsp), %rdx
        syscall

        pop %rax
        cmp $0, %rax
        jne read

    pop %rax
    mov $60, %rax
    syscall

.data
s:
    .asciz "main.s"
