.section .data
    message1: .string "Os numeros sao iguais\n"
    message2: .string "Os numeros nao sao iguais\n"

    numero_um: .int 0
    numero_dois: .int 0
    scan_str: .string "%d %d"
    infostr: .string "Insira 2 numero inteiros: '(numero1) (numero2)': \n"

.section .text
.global _start

_start:
    pushl $infostr
    call printf
    addl $4, %esp

    pushl $numero_dois
    pushl $numero_um
    pushl $scan_str
    call scanf

    movl numero_um, %eax
    cmpl numero_dois,%eax
    je equal
    pushl $message2
    call printf
    addl $4, %esp
    jmp end

    equal: pushl $message1
    call printf
    addl $4, %esp
    jmp end

    end: pushl $0
    call exit