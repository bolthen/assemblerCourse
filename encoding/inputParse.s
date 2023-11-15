
.text
### Parse string to integer
### Input in stack: string pointer with value
### Output: integer value in rax
getValue:
    push %rbp
    mov %rsp, %rbp

    mov +16(%rbp), %rsi
    mov $0, %rax
    mov $10, %rbx

1:
    mov $0, %rdx
    mov $0, %rcx
    mov (%rsi), %cl
    cmp %cl, %dl
    je 2f
    cmp %cl, %bl
    je 2f
    mul %rbx
    sub $48, %cl
    add %rcx, %rax
    inc %rsi
    jmp 1b

2:
    pop %rbp
    ret


### Put integer value to buffer
### Input in stack: integer value
###                 pointer to the last byte of buffer, will point to the beginning of the buffer
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
