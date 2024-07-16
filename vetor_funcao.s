.section .data
    v1: .space 32
    zero_number: .int 0
    numbers_to_insert: .int 7
    triangular_amount: .int 0
    initial_mul_number: .int 1
    
    scan_string: .string "%d"
    info_string: .string "Digite um numero: \n"
    result_string: .string "A quantidade de numeros triangulares sao: %d\n"


.text
.globl _start

_start:
    movl $v1, %edi
    jmp loop_insert


loop_insert:
    pushl $info_string
    call printf
    addl $4, %esp

    pushl %edi
    pushl $scan_string
    call scanf
    addl $8, %esp

    movl $1, initial_mul_number
    call verifica_triangular

    retorna_insercao:
        addl $4, %edi
        movl numbers_to_insert, %eax
        decl numbers_to_insert
        cmpl zero_number, %eax
        jne loop_insert

        jmp termina_programa


verifica_triangular:
    movl (%edi), %ebx

    multiplicacao:
        movl initial_mul_number, %eax
        movl %eax, %ecx
        addl $1, %ecx
        imull %ecx, %eax
        addl $1, %ecx
        imull %ecx, %eax
        cmpl %ebx, %eax
        jg retorna_insercao
        je encontra_triangular
        addl $1, initial_mul_number
        jmp multiplicacao

encontra_triangular:
    addl $1, triangular_amount
    ret

termina_programa:
    pushl triangular_amount
    pushl $result_string
    call printf
    addl $8, %esp

    pushl $0
    call exit


    