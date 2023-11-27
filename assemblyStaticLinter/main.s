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
    jmp print

other:
    mov $otherColor, %rdi
    jmp print

keyword:
    mov $keywordColor, %rdi

print:
    mov (%rdi), %rdi
    movq %rdi, spaces

    mov $0, %rdx            # state: 0 == first spaces, 1 == first word, 2 == after first word
    mov +32(%rax), %rcx     # size to copy
    mov +24(%rax), %rsi     # src
    mov $tmpBuffer, %rdi    # dst

parse:
    movb (%rsi), %bl

startSpacesState:
    cmpq $0, %rdx
    jne firstWordState
    cmpb $' ', %bl
    je copy
    cmpb $'\t', %bl
    je copy
    # then firstWordState
    mov $1, %rdx

firstWordState:
    cmpq $1, %rdx
    jne afterFirstWordState
    cmpb $' ', %bl
    jne copy                    # still firstWordState
    # else next state
    mov $2, %rdx

    mov $spaces, %r8
    mov $otherColor, %r9
    mov (%r8), %r8
    mov (%r9), %r9
    cmpq %r8, %r9
    jne afterFirstWordState     # then not instruction line

    # else copy operand color to dst buffer
    push %rcx
    push %rsi
    mov $5, %rcx
    mov $operandColor, %rsi
    addq $5, +32(%rax)          # + size to result buffer, because esp size
1:
    movsb
    loop 1b
    pop %rsi
    pop %rcx

afterFirstWordState:
    cmpq $1, %rdx
    jne copy

copy:
    movsb
    loop parse

    # print result buffer
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
    .ascii "   \x1b[33m"
markColor:
    .ascii "   \x1b[31m"
otherColor:
    .ascii "   \x1b[34m"
operandColor:
    .ascii "\x1b[32m"


spaces:
    .space 3
colorEscape:
    .ascii "\x1b[31m"
tmpBuffer:
    .space 128
bufferColorLen=.-colorEscape
