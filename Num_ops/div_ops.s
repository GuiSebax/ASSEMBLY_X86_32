.section .data
    format_in: .asciz "%d"
    format_out: .asciz "Dividendo: %d, Divisor: %d, Quociente: %d, Resto: %d\n"
    num1: .long 0
    num2: .long 0
    quotient: .long 0
    remainder: .long 0


.section .text
.global _start

_start:

    # Chamar scanf para num1
    pushl $num1
    pushl $format_in
    call scanf
    addl $8, %esp

    # Chamar scanf para num2
    pushl $num2
    pushl $format_in
    call scanf
    addl $8, %esp

    # Calcular quociente e resto
    movl num1, %eax
    cdq
    idivl num2
    movl %eax, quotient
    movl %edx, remainder

    # Chamar printf
    pushl remainder
    pushl quotient
    pushl num2
    pushl num1
    pushl $format_out
    call printf
    addl $20, %esp # Limpar a pilha

    # Chamar o exit
    pushl $0
    call exit
    