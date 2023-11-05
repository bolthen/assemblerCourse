.include "inputParse.asm"


.data
1:
    .fill 50, 1, 0
2:
    .ascii "\n"
ls=.-1b


.text
readInt:
    mov %rsp, %rbp

    mov $0, %rax
    mov $0, %rdi
    mov $1b, %rsi
    mov $ls, %rdx
    syscall

    pushq $1b
    call getValue

    mov %rbp, %rsp

    ret


writeInt:
    push %rbp
    mov %rsp, %rbp

    push +16(%rbp)
    pushq $2b

    call valueToBuffer

    mov $1, %rax
    mov $1, %rdi
    mov -16(%rbp), %rsi
    mov $2b, %rdx
    sub %rsi, %rdx
    inc %rdx
    syscall

    mov %rbp, %rsp
    pop %rbp
    ret
