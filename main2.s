.section .data
    # Mensagens e Formatos
    menu: .string "Menu:\n1 - Menores e Maiores\n2 - Busca Binária\n3 - Sair\nEscolha uma opção: "
    input_valor: .string "%d"
    input_float: .string "%f"
    msg_sair: .string "Saindo.....\n"
    opcao_invalidas: .string "Opção inválida!\n"
    msg_menores: .string "Valores menores ou iguais ao pivo:\n"
    msg_maiores: .string "Valores maiores que o pivo:\n"
    msg_encontrado: .string "Valor encontrado no vetor.\n"
    msg_nao_encontrado: .string "Valor nao encontrado no vetor.\n"

    # Buffers e Variáveis
    valores: .space 32  # Espaço para 8 floats (4 bytes cada)
    menores: .space 32
    maiores: .space 32
    pivo: .float 0.0
    quantidade: .int 0
    busca_valor: .float 0.0
    vetor: .space 1024  # Espaço para 256 floats (4 bytes cada)

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
    call inserir_valores
    call inserir_pivo
    call separar_valores
    call mostrar_menores_maiores
    jmp mostrar_menu

inserir_valores:
    movl $8, %ecx
    leal valores, %esi
    
inserir_loop:
    pushl $input_float
    pushl %esi
    call scanf
    addl $8, %esp
    addl $4, %esi
    loop inserir_loop
    ret

inserir_pivo:
    pushl $input_float
    leal pivo, %esi
    call scanf
    addl $8, %esp
    ret

separar_valores:
    leal valores, %esi
    leal menores, %edi
    leal maiores, %ebx
    movl $8, %ecx

    fldz                    # Carregar 0.0 na pilha da FPU
    
separar_loop:
    fld dword ptr [esi]     # Carregar o valor da memória para a FPU
    fld dword ptr pivo      # Carregar o pivô para a FPU
    fcomip %st(1), %st(0)  # Comparar ST(0) (valor atual) com ST(1) (pivô)
    jbe _menor_ou_igual    # Se ST(0) <= ST(1), pular para _menor_ou_igual
    fstp dword ptr [ebx]   # Armazenar ST(0) em maiores
    addl $4, %ebx
    jmp _next

_menor_ou_igual:
    fstp dword ptr [edi]   # Armazenar ST(0) em menores
    addl $4, %edi

_next:
    addl $4, %esi
    loop separar_loop
    ret

mostrar_menores_maiores:
    pushl $msg_menores
    call printf
    addl $4, %esp
    lea menores, %esi
    movl $8, %ecx

mostrar_menores_loop:
    fld dword ptr [esi]
    call printf_float
    addl $4, %esi
    loop mostrar_menores_loop

    pushl $msg_maiores
    call printf
    addl $4, %esp
    lea maiores, %esi
    movl $8, %ecx

mostrar_maiores_loop:
    fld dword ptr [esi]
    call printf_float
    addl $4, %esi
    loop mostrar_maiores_loop
    ret

busca_binaria:
    call inserir_quantidade
    call inserir_vetor
    call ordenar_vetor
    call inserir_busca_valor
    call buscar_valor
    jmp mostrar_menu

inserir_quantidade:
    pushl $input_valor
    lea quantidade, %esi
    call scanf
    addl $8, %esp
    ret

inserir_vetor:
    lea vetor, %esi
    movl quantidade, %ecx

inserir_vetor_loop:
    pushl $input_float
    pushl %esi
    call scanf
    addl $8, %esp
    addl $4, %esi
    loop inserir_vetor_loop
    ret

ordenar_vetor:
    lea vetor, %esi
    movl quantidade, %ecx
    subl $1, %ecx

ordenar_loop:
    lea vetor, %edi
    movl %ecx, %ebx

ordenar_inner_loop:
    fld dword ptr [edi]
    fld dword ptr [edi+4]
    fcomip %st(1), %st(0)
    jae no_swap
    fstp dword ptr [edi]
    fstp dword ptr [edi+4]
    movl %edi, %edx
    addl $4, %edx
    movl %edx, %edi

no_swap:
    addl $4, %edi
    loop ordenar_inner_loop
    subl $1, %ecx
    jnz ordenar_loop
    ret

inserir_busca_valor:
    pushl $input_float
    lea busca_valor, %esi
    call scanf
    addl $8, %esp
    ret

buscar_valor:
    lea vetor, %esi
    movl quantidade, %ecx
    xorl %ebx, %ebx
    subl $1, %ecx

buscar_loop:
    movl %ecx, %eax
    shr $1, %eax
    lea [esi+%eax*4], %edi
    fld dword ptr [edi]
    fld dword ptr busca_valor
    fcomip %st(1), %st(0)
    jz encontrado
    fstp %st(0)
    fstp %st(0)
    jg menor
    subl $1, %ecx
    jmp buscar_loop

menor:
    addl $1, %ebx
    jmp buscar_loop

encontrado:
    pushl $msg_encontrado
    call printf
    addl $4, %esp
    ret

opcao_invalida:
    pushl $opcao_invalidas
    call printf
    addl $4, %esp
    jmp mostrar_menu

sair:
    pushl $msg_sair
    call printf
    addl $4, %esp

    movl $1, %eax
    movl $0, %ebx
    int $0x80

printf_float:
    subl $4, %esp       # Alocar espaço para o float
    movl $1, %eax       # Número da chamada do sistema para printf
    movl $1, %ebx       # File descriptor para stdout
    movl %esp, %ecx     # Endereço do float
    movl $0, %edx       # Nenhum argumento adicional
    int $0x80           # Chamada do sistema
    addl $4, %esp       # Liberar espaço
    ret
