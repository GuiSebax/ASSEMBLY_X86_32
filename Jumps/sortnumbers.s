.section .data 
    number_one: .int 0
    number_two: .int 0
    number_three: .int 0
    scan_string: .string "%d %d %d"
    result_string: .string "Numero Ordenados: %d, %d, %d\n"
    info_string: .string "Insira 3 numeros para ordenar: (1) (2) (3)\n"
    collected_string: .string "Numeros coletados: %d, %d, %d\n"


.section .text
.global _start

_start:
    pushl $info_string
    call printf
    addl $4, %esp

    pushl $number_one
    pushl $number_two
    pushl $number_three
    pushl $scan_string
    call scanf
    addl $16, %esp

    movl number_one, %eax
    movl number_two, %ebx
    movl number_three, %ecx

    # Ordenar os numeros
    cmpl %ebx, %eax
    jle first_second

    cmpl %ecx, %eax
    jle first_third

    cmpl %ecx, %ebx
    jle second_third

    jmp print_sorted

    pushl $0

    call exit


first_second:
    movl %ebx, %edx
    movl %eax, %ebx
    movl %edx, %eax

    cmpl %ecx, %ebx
    jle second_third

    jmp print_sorted

first_third:
    movl %ecx, %edx
    movl %eax, %ecx
    movl %edx, %eax

    cmpl %ebx, %eax
    jle first_second

    cmpl %ecx, %ebx
    jle second_third

    jmp print_sorted


second_third:
    movl %ecx, %edx
    movl %ebx, %ecx
    movl %edx, %ebx

    cmpl %ebx, %eax
    jle first_second

    cmpl %ecx, %eax
    jle first_third

    jmp print_sorted


print_sorted:
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl $result_string
    call printf
    add $16, %esp

    pushl $0
    call exit
