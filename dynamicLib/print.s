# gcc -shared print.s -o libprint.so
.globl print

.text
print:
    push %rbp
    mov %rsp, %rbp

    and $~15, %rsp

    mov %rdi, %rsi
    lea s(%rip), %rdi
    call printf@plt

    mov %rbp, %rsp
    pop %rbp

    ret

.data
s:
    .asciz "%d\n"
