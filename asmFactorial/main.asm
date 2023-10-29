.global _start
.data
str:
.ascii "                             \n"
lstr=.-str


.text
_start:
    mov $0, %rax
    mov $0, %rdi
    mov $str, %rsi
    mov $lstr, %rdx
    syscall

    mov $str, %rsi
    mov $0, %rax
    mov $10, %rbx
    mov $0, %rcx

parseStep:
    mov (%rsi), %cl
    cmp %cl, %bl
    je stopParse
    mul %rbx
    sub $48, %cl
    add %rcx, %rax
    inc %rsi
    jmp parseStep

stopParse:
    mov $0, %rsi
    mov %rax, %rbx
    mov $1, %rax

factorialStep:
    inc %rsi
    mul %rsi
    cmp %rsi, %rbx
    jne factorialStep

    mov $lstr - 1, %rsi
    mov $0, %rdi
    mov $10, %rbx
    mov $0, %rbp

valueToBuffer:
    dec %rsi
    div %rbx
    add $48, %dl
    mov %dl, str(%rsi)
    inc %rdi
    mov $0, %rdx
    cmp %rax, %rbp
    jne valueToBuffer

printResult:
    mov $1, %rax
    mov %rdi, %rdx
    add $1, %rdx
    mov $1, %rdi
    add $str, %rsi
    syscall

return:
    mov $0, %rdi
    mov $60, %rax
    syscall
