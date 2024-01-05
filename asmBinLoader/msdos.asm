execute_size equ exec_end-exec_start
dq execute_size
data_size equ data_end - data_start
dq data_size


exec_start:
    use64
    mov rax, 1
    mov rdi, 1
    lea rsi, [rbp + hello_msg]
    mov rdx, hello_msg_len
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
    
exec_end:
    org 0
data_start:
    hello_msg db 'Hello, World!!!!', 0
    hello_msg_len = $-hello_msg
data_end:
    end_msg db '\n', 0
