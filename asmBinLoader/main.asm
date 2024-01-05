.globl _start

.set PROT_READ_WRITE, 0x3
.set PROT_READ_EXEC, 0x5
.set MAP_ANONYMOUS_PRIVATE, 0x22
.set READ_BUFFER_SIZE, 1000

.data
file_descriptor:
    .quad 0
execution_size:
    .quad 0
execution_addr:
    .quad 0
data_size:
    .quad 0
data_addr:
    .quad 0

.text
_start:
    add $16, %rsp

    # open
    mov $2, %rax
    pop %rdi
    xor %rsi, %rsi
    syscall

    # file descriptor, (%rsp)
    mov %rax, file_descriptor

    # read execution size
    mov $0, %rax
    mov file_descriptor, %rdi
    mov $execution_size, %rsi
    mov $8, %rdx
    syscall

    # read data_size
    mov $0, %rax
    mov file_descriptor, %rdi
    mov $data_size, %rsi
    mov $8, %rdx
    syscall

    # allocate execution memory
    mov $9, %rax
    mov $0, %rdi
    mov execution_size, %rsi
    mov $PROT_READ_WRITE, %rdx
    mov $-1, %r8
    mov $0, %r9
    mov $MAP_ANONYMOUS_PRIVATE, %r10
    syscall
    mov %rax, execution_addr

    # allocate data memory
    mov $9, %rax
    mov $0, %rdi
    mov data_size, %rsi
    mov $PROT_READ_WRITE, %rdx
    mov $-1, %r8
    mov $0, %r9
    mov $MAP_ANONYMOUS_PRIVATE, %r10
    syscall
    mov %rax, data_addr

    # execution binary to execution area
    mov $0, %rax
    mov file_descriptor, %rdi
    mov execution_addr, %rsi
    mov execution_size, %rdx
    syscall

    # change protect rights
    mov $10, %rax
    mov execution_addr, %rdi
    mov execution_size, %rsi
    mov $PROT_READ_EXEC, %rdx
    syscall

    # data binary to data area
    mov $0, %rax
    mov file_descriptor, %rdi
    mov data_addr, %rsi
    mov data_size, %rdx
    syscall

here:
    mov data_addr, %rbp
    # or just jmp *execution_addr
    mov execution_addr, %rax
    jmp %rax

    # до сюда не дойдёт

    # write
    mov $1, %rax
    mov $1, %rdi
    mov data_addr, %rsi
    mov $20, %rdx
    syscall

    # return
    mov $60, %rax
    mov data_size, %rdi
    syscall
