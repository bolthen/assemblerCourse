.include "streamReader.s"

.globl _start

.text
_start:
    add $16, %rsp
    pop %rdi

    mov %rsp, %rbp

    mov $2, %rax
    xor %rsi, %rsi
    syscall

    push %rax           # дескриптор
    call newReaderInfo
    pop %rbx

    push %rax           # ReaderInfo, -8(%rbp)

read:
    call getline
    mov (%rsp), %rax

    mov +32(%rax), %rbx
    cmpq $0, +32(%rax)
    je return           # if resultBufferIdx == 0

    mov +24(%rax), %rbx
    movb (%rbx), %bl
    cmpb $'.', %bl
    je keyword

    cmpb $' ', %bl
    je other
    cmpb $'\t', %bl
    je other

mark:
    mov $markColor, %rdi
    mov (%rdi), %rdi
    movq %rdi, spaces
    jmp print

other:
    mov $otherColor, %rdi
    mov (%rdi), %rdi
    movq %rdi, spaces
    jmp print

keyword:
    mov $keywordColor, %rdi
    mov (%rdi), %rdi
    movq %rdi, spaces

print:
    mov $0, %rdx            # flag
    mov +32(%rax), %rcx
    mov +24(%rax), %rsi
    mov $tmpBuffer, %rdi

copy:
    movb (%rsi), %bl
    cmp $1, %rdx
    jg 2f
    je 1f
    cmpb $' ', %bl
    je 2f
    cmpb $'\t', %bl
    je 2f
    mov $1, %rdx

1:
    mov $spaces, %r8
    mov $otherColor, %r9
    mov (%r8), %r8
    mov (%r9), %r9
    cmp %r8, %r9
    jne 2f
    cmp $1, %rdx
    jne 2f
    # after instruction
    cmpb $' ', %bl
    jne 2f
    push %rcx
    push %rsi
    mov $5, %rcx
    mov $operandColor, %rsi
    addq $5, +32(%rax)

5:
    movsb
    loop 5b
    pop %rsi
    pop %rcx
    mov $2, %rdx

2:
    movsb
    loop copy

3:
    mov $1, %rdi
    mov $colorEscape, %rsi
    mov +32(%rax), %rdx
    add $5, %rdx
    mov $1, %rax
    syscall

    jmp read

return:
    mov %rbp, %rsp

    mov $60, %rax
    syscall


.data
keywordColor:
    .ascii "   \x1b[32m"
markColor:
    .ascii "   \x1b[31m"
otherColor:
    .ascii "   \x1b[34m"
operandColor:
    .ascii "\x1b[33m"


spaces:
    .space 3
colorEscape:
    .ascii "\x1b[31m"
tmpBuffer:
    .space 128
bufferColorLen=.-colorEscape
