.global _start
.data
str:
.ascii "hello world\n"
lstr=.-str


.text
_start:
  mov $0, %rax
  mov $0, %rdi
  mov $str, %rsi
  mov $lstr, %rdx
  syscall
  
  mov $str, %rsi
  mov $0, %RAX
  mov $10, %rbx
  mov $0, %rcx
  
start:
  mov (%rsi), %cl
  cmp %cl, %bl
  JE st
  mul %rbx
  sub $48, %cl
  add %rcx, %rax
  inc %rsi
  jmp start  
st:
  mov %rax, %rdi
  mov $60, %rax
  syscall
