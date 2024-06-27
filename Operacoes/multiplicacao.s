.section .data
    value1: .long 10
    value2: .long 2
    value3: .long 5
    formatstr: .asciz "Resultado da multiplicacao: %ld\n"

.text
.global _start

_start:
    # multiplicacao de 3 valores ( 10 x 2 x 5)
    movl value1, %eax
    movl value2, %ebx
    mull %ebx

    movl value3, %ebx
    mull %ebx

    pushl %eax
    pushl $formatstr
    call printf
    pushl $0
    call exit

    