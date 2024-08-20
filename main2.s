.section .data
    menu: .string "Menu:\n1 - Menores e Maiores\n2 - Busca Binária\n3 - Sair\nEscolha uma opção: "
    opcao: .int 0
    input_valor: .string "%d"
    msg_sair: .string "Saindo.....\n"
    opcao_invalidas: .string "Opção inválida!\n"

.section .text
.globl _start

_start:
    call mostrar_menu

mostrar_menu:
    pushl $menu
    call printf
    addl $4, %esp

    movl $opcao, %eax
    pushl %eax
    pushl $input_valor
    call scanf
    addl $8, %esp

    movl opcao, %eax
    cmpl $1, %eax
    je menores_maiores
    cmpl $2, %eax
    je busca_binaria
    cmpl $3, %eax
    je sair
    call opcao_invalida
    jmp mostrar_menu


menores_maiores:
    jmp sair

busca_binaria:
    jmp sair

sair: 
    pushl $msg_sair
    call printf
    addl $4, %esp

    movl $1, %eax
    movl $0, %ebx
    int $0x80

opcao_invalida:
    pushl $opcao_invalidas
    call printf
    addl $4, %esp
    jmp mostrar_menu