.include "inputParse.asm"

.data
buffer:
    .space 32
bufferEnd:
    .ascii "\n"
bufferLen=.-buffer

.text
.global _start
_start:
    pop %rcx
    pop %rax    # мусор
    pop %rax
    dec %rcx
    dec %rcx
    push %rcx
    push %rax

    call getValue
    pop %rdx    # уже обработанное число
    pop %rcx    # количество оставшихся аргументов

p:
    dec %rcx
    pop %rdx    # операция
    pop %rbx    # следующее число
    push %rcx
    push %rax   # сумма
    push %rbx

plus:
    mov $43, %rax
    cmp %al, (%rdx)
    jne minus
    call getValue
    pop %rbx
    add %rax, (%rsp)
    pop %rax
    jmp endOp

minus:
    mov $45, %rax
    cmp %al, (%rdx)
    jne multiple
    call getValue
    pop %rbx
    sub %rax, (%rsp)
    pop %rax
    jmp endOp

multiple:
    mov $94, %rax
    cmp %al, (%rdx)
    jne divide
    call getValue
    pop %rbx
    pop %rcx
    mul %rcx
    jmp endOp

divide:
    call getValue
    pop %rbx
    mov $0, %rdx
    pop %rcx
    xchg %rcx, %rax
    div %rcx

endOp:
    pop %rcx
    loop p

    push %rax
    mov $bufferEnd, %rsi
    push %rsi
    call valueToBuffer

    mov $1, %rax
    mov $1, %rdi
    pop %rsi
    mov $bufferEnd+1, %rdx
    sub %rsi, %rdx
    syscall

    mov $60, %rax
    syscall
