
.set PROT_READ_WRITE, 0x3
.set MAP_ANONYMOUS_PRIVATE, 0x22
.set READ_BUFFER_SIZE, 1000


.text
    # size: 48 bytes
    # struct ReaderInfo {
    #     int64 fileDescriptor;     // +0
    #     char*  buffer;            // +8
    #     int64  bufferReadIdx;     // +16
    #     char*  resultBuffer;      // +24
    #     int64 resultBufferIdx;    // +32
    #     int64 bytesRemeining;     // +40
    # };
# stack:
#       fileDescriptor
newReaderInfo:
    push %rbp
    mov %rsp, %rbp

    # allocate for ReaderInfo
    mov $9, %rax
    mov $0, %rdi
    mov $48, %rsi
    mov $PROT_READ_WRITE, %rdx
    mov $-1, %r8
    mov $0, %r9
    mov $MAP_ANONYMOUS_PRIVATE, %r10
    syscall

    push %rax

    # allocate for ReaderInfo::buffer
    mov $9, %rax
    mov $0, %rdi
    mov $READ_BUFFER_SIZE, %rsi
    mov $PROT_READ_WRITE, %rdx
    mov $-1, %r8
    mov $0, %r9
    mov $MAP_ANONYMOUS_PRIVATE, %r10
    syscall

    mov +16(%rbp), %rdi
    mov %rax, %rbx
    pop %rax
    movq %rdi, (%rax)       # fileDescriptor
    movq %rbx, +8(%rax)     # buffer
    movq $0, +16(%rax)      # bufferReadIdx = 0
    movq $0, +32(%rax)      # resultBufferIdx = 0
    movq $0, +40(%rax)      # bytesRemeining = 0

    push %rax

    # allocate for ReaderInfo::resultBuffer
    mov $9, %rax
    mov $0, %rdi
    mov $128, %rsi
    mov $PROT_READ_WRITE, %rdx
    mov $-1, %r8
    mov $0, %r9
    mov $MAP_ANONYMOUS_PRIVATE, %r10
    syscall

    mov %rax, %rbx
    pop %rax
    movq %rbx, +24(%rax)    # resultBuffer

    mov %rbp, %rsp
    pop %rbp
    ret


# stack:
#       ReaderInfo, +16(%rbp)
getline:
    push %rbp
    mov %rsp, %rbp

    mov +16(%rbp), %rax

    movq $0, +32(%rax)      # resultBufferIdx = 0

1:  # read to buffer
    cmpq $0, +40(%rax)      # bytesRemeining
    jne 2f                  # if bytesRemeining != 0

    movq $0, +16(%rax)      # bufferReadIdx = 0

    mov (%rax), %rdi        # fileDescriptor
    mov +8(%rax), %rsi      # buffer
    mov $0, %rax
    mov $READ_BUFFER_SIZE, %rdx
    syscall

    mov %rax, %rbx
    mov +16(%rbp), %rax
    movq %rbx, +40(%rax)    # bytesRemeining
    cmpq $0, %rbx
    je 4f                   # if read 0 bytes

tmp:
2:
    mov +16(%rbp), %rax

    movq +8(%rax), %rdx     # buffer to rdx
    movq +24(%rax), %rdi    # resultBuffer to rdi

3:  # read line character-by-character
    movq +16(%rax), %rcx    # bufferReadIdx to rcx
    movq +32(%rax), %rsi    # resultBufferIdx to rsi

    # resultBuffer[resultBufferIdx] = buffer[bufferReadIdx]
    movb (%rdx, %rcx), %bl
    movb %bl, (%rdi, %rsi)

    incq +16(%rax)          # ++bufferReadIdx
    incq +32(%rax)          # ++resultBufferIdx
    decq +40(%rax)          # --bytesRemeining

    cmpb $'\n', %bl
    je 4f

    cmpq $0, +40(%rax)
    je 1b
    jmp 3b

4:  # return

    xor %rax, %rax
    mov %rbp, %rsp
    pop %rbp
    ret
