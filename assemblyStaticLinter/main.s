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

print:
    mov $1, %rdi
    mov +24(%rax), %rsi
    mov +32(%rax), %rdx
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


spaces:
    .space 3
colorEscape:
    .ascii "\x1b[31m"
tmpBuffer:
    .space 128
bufferColorLen=.-colorEscape
