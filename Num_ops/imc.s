.section .data
    format_in: .asciz "%d"
    format_out: .asciz "IMC: %d\n"
    altura: .long 0
    peso: .long 0
    bmi: .long 0

.section .text
.global _start

_start:
    # Chamar scanf para a altura
    pushl $altura
    pushl $format_in
    call scanf
    addl $8, %esp # Limpar a pilha

    # Chamar scanf para o peso
    pushl $peso
    pushl $format_in
    call scanf
    addl $8, %esp # Limpar a pilha

    # Calcular o IMC (IMC = peso / altura ^ 2)
    
    movl altura, %eax
    imull altura, %eax
    movl %eax, %ebx
    movl peso, %eax
    imull $10000, %eax
    cdq
    idivl %ebx
    movl %eax, bmi

    pushl bmi
    pushl $format_out
    call printf
    addl $8, %esp

    pushl $0
    call exit

