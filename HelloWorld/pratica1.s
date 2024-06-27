.section .data 
    message: .asciz "Hello World\n"

.text
.global _start

_start:
    movl $message, %ebx
    pushl %ebx
    call printf
    addl $4, %esp
    pushl $0
    call exit

    

    