.global main
.text
main:
    mov $name, %rdi
    mov $100500, %rsi
    mov $0, %rax
    call printf
	
	ret

.data
name:
    .asciz "hello %d"

