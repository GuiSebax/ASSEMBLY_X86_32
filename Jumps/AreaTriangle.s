.section .data 
    side_a: .int 0
    side_b: .int 0
    side_c: .int 0
    scan_string: .string "%d %d %d"
    info_string: .string "Insira os lados do triangulo: (A) (B) (C)\n"
    result_isosceles: .asciz "Este triangulo eh Isosceles\n"
    result_equilatero: .asciz "Este triangulo eh Equilatero\n"
    result_escaleno: .asciz "Este triangulo eh Escaleno\n"
    result_final: .asciz "Esta figura nao representa um triangulo\n"

.section .text
.global _start

_start: 
    # Print the info_string
    pushl $info_string
    call printf
    addl $4, %esp

    # Read side_a, side_b, side_c
    pushl $side_a
    pushl $side_b
    pushl $side_c
    pushl $scan_string
    call scanf
    addl $16, %esp

    # Load side_a, side_b, side_c into registers
    movl side_a, %eax
    movl side_b, %ebx
    movl side_c, %ecx

    # Check if it's a triangle: a + b > c, a + c > b, b + c > a
    movl %eax, %edx
    addl %ebx, %edx
    cmpl %ecx, %edx
    jle not_triangle

    movl %eax, %edx
    addl %ecx, %edx
    cmpl %ebx, %edx
    jle not_triangle

    movl %ebx, %edx
    addl %ecx, %edx
    cmpl %eax, %edx
    jle not_triangle

    # Check if it's Equilatero: a == b && b == c
    cmpl %ebx, %eax
    jne check_isosceles
    cmpl %ecx, %eax
    je equilatero

check_isosceles:
    # Check if it's Isosceles: a == b || a == c || b == c
    cmpl %ebx, %eax
    je isosceles
    cmpl %ecx, %eax
    je isosceles
    cmpl %ecx, %ebx
    je isosceles

    # If it's not Equilatero or Isosceles, it must be Escaleno
    pushl $result_escaleno
    call printf
    addl $4, %esp
    jmp end_program

equilatero:
    pushl $result_equilatero
    call printf
    addl $4, %esp
    jmp end_program

isosceles:
    pushl $result_isosceles
    call printf
    addl $4, %esp
    jmp end_program

not_triangle:
    pushl $result_final
    call printf
    addl $4, %esp

end_program:
    pushl $0
    call exit
