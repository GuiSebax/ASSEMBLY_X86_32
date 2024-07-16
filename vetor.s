.section .data
    text1: .asciz "Soma: %d\n"
    v1: .int 5, 10, 20

.text
.global _start

_start:
    movl $v1, %edi
    movl (%edi), %eax
    addl $4, %edi
    addl (%edi), %eax
    addl $4, %edi
    addl (%edi), %eax

    pushl %eax
    pushl $text1
    call printf
    
    pushl $0
    call exit
    
