
.text
getValue:
    push %rbp
    mov %rsp, %rbp

    mov +16(%rbp), %rsi
    mov $0, %rax
    mov $10, %rbx
    mov $0, %rdi

1:
    mov (%rsi), %cl
    cmp %cl, %dl
    je 2f
    mul %rbx
    sub $48, %cl
    add %rcx, %rax
    inc %rsi
    jmp 1b

2:
    pop %rbp
    ret


valueToBuffer:
    push %rbp
    mov %rsp, %rbp

    mov +24(%rbp), %rax
    mov +16(%rbp), %rsi
    mov $10, %rbx
    mov $0, %rdx

1:
    dec %rsi
    div %rbx
    add $48, %dl
    mov %dl, (%rsi)
    mov $0, %rdx
    cmp %rax, %rdx
    jne 1b

    mov %rsi, +16(%rbp)
    pop %rbp
    ret

