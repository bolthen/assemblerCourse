.include "reader.s"
.globl _start

.data
buffer:
    .space 32
bufferEnd:
    .ascii "\n"


.text
_start:
    call readInt
    push %rax
    call readInt
    mov %rax, %rsi  # СС
    pop %rax        # число

    mov $bufferEnd, %rcx

    step:
        dec %rcx
        mov $0, %rdx
        div %rsi

        cmp $9, %rdx
        jle 1f
        add $7, %rdx
    1:
        add $48, %rdx
        movb %dl, (%rcx)

        cmp $0, %rax
        jne step

    mov $1, %rax
    mov $1, %rdi
    mov $buffer, %rsi
    mov $33, %rdx
    syscall

    mov %rax, %rdi
    mov $60, %rax
    syscall
