.section .data
    strone: .ascii "Primeira String\n"
    strtwo: .ascii "Segunda String\n"

.section .text
.global _start

_start:
    movl $strone, %eax
    pushl %eax
    call printf

    movl $strtwo, %eax
    pushl %eax
    call printf

    movl $strone, %eax
    pushl %eax
    jmp R1
    call printf

    R1: movl $strtwo, %eax
    pushl %eax
    call printf

    pushl $0

    call exit