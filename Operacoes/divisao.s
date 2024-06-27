.section .data
    divisor: .long 2
    dividend: .long 10
    formatstr: .asciz "Resultado da divisao: %ld\n"

.text
.global _start

_start:
    movl dividend, %eax
    movl divisor, %ebx
    cdq
    idivl %ebx
    pushl %eax
    pushl $formatstr
    call printf
    addl $8, %esp
    pushl $0
    call exit   