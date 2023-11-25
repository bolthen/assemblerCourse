.globl _start

.set PROT_READ_WRITE, 0x3
.set MAP_ANONYMOUS_PRIVATE, 0x22

.text
_start:
    add $16, %rsp
    pop %rdi

    mov %rsp, %rbp

    mov $2, %rax
    xor %rsi, %rsi
    syscall

    push %rax                       # -8(%rbp) дескриптор

    mov $9, %rax
    mov $0, %rdi
    mov $4096, %rsi
    mov $PROT_READ_WRITE, %rdx
    mov $-1, %r8
    mov $0, %r9
    mov $MAP_ANONYMOUS_PRIVATE, %r10
    syscall

    push %rax                       # -16(%rbp) начало выделенной памяти
    push $0                         # -24(%rbp) индекс в tmpBuffer, который будем выводить, куда копируем символы

read:
        mov $0, %rax
        mov -8(%rbp), %rdi
        mov -16(%rbp), %rsi
        mov $4096, %rdx
        syscall

        mov %rax, %rcx              # количество прочитанных байт в текущей итерации
        mov -16(%rbp), %rbx         # указатель на текущий прочитанный символ

parseStep:
            cmpq $0, -24(%rbp)      # если начало строки, то выбираем цвет
            jne lineParse

eyword:
            cmpb $'.', (%rbx)
            jne mark
            mov $keywordColor, %rax
            jmp putColor

mark:
            cmpb $' ', (%rbx)
            je other
            mov $markColor, %rax
            jmp putColor

other:
            mov $otherColor, %rax

putColor:
            mov (%rax), %rax
            movq %rax, spaces

lineParse:
                mov -24(%rbp), %rax
                mov (%rbx), %rdx
                movb %dl, tmpBuffer(%rax)
                incq -24(%rbp)

                cmpb $10, (%rbx)
                je print

                inc %rbx
                dec %rcx
                jmp lineParse

print:
                inc %rbx
                dec %rcx

                # дочитали до конца строки, выводим буфер вместе с цветом
                push %rcx
                push %rbx
                mov $1, %rax
                mov $1, %rdi
                mov $colorEscape, %rsi
                mov -24(%rbp), %rdx
                add $5, %rdx
                syscall
                pop %rbx
                pop %rcx

                # возвращаем указатель на буффер в переменную
                movq $0, -24(%rbp)

            cmp $0, %rcx
            jne parseStep

        cmp $0, %rax
        jne read

return:
    mov %rbp, %rsp

    pop %rax
    mov $60, %rax
    syscall


.data
keywordColor:
    .ascii "   \x1b[31m"
markColor:
    .ascii "   \x1b[34m"
otherColor:
    .ascii "   \x1b[32m"


spaces:
    .space 3
colorEscape:
    .ascii "\x1b[31m"
tmpBuffer:
    .space 128
bufferColorLen=.-colorEscape
