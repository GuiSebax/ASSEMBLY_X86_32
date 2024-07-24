.section .data
linhas: .int 0
colunas: .int 0
entrada: .string "Preencha a matriz (%d x %d):\n"
entrada_linhas: .string "Digite o número de linhas da matriz: "
entrada_colunas: .string "Digite o número de colunas da matriz: "
input_valor: .string "%d"
fill: .string "Elemento [%d][%d]: "
val_temp: .int 0
nova_linhas: .string "\n"
menu: .string "Menu:\n1 - Preencher matriz NxM\n2 - Buscar elemento na matriz\n3 - Mostrar diagonal principal\n4 - Mostrar lucky numbers\n5 - Sair\nEscolha uma opção: "
opcao_invalidas: .string "Opção inválida!\n"
msg_sair: .string "Saindo... Tenha um bom dia!\n"
buscar_linha: .string "Digite a linha do elemento a buscar: "
buscar_coluna: .string "Digite a coluna do elemento a buscar: "
elemento_encontrado: .string "Elemento encontrado: %d\n"
lucky_number_msg: .string "Lucky number encontrado: %d\n"
mostrar_matriz_msg: .string "Matriz (%d x %d):\n"
debug_msg: .string "Valor lido: %d\n"
debug_store: .string "Armazenando na matriz[%d][%d]: %d\n"
debug_matrix: .string "Valor na matriz[%d][%d]: %d\n"

.section .bss
matriz: .int 0  # Posição para armazenar o endereço da matriz
opcao: .int 0
linha_busca: .int 0
coluna_busca: .int 0

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
    je preencher_matriz
    cmpl $2, %eax
    je buscar_elemento
    cmpl $3, %eax
    je mostrar_diagonal
    cmpl $4, %eax
    je mostrar_lucky_numbers
    cmpl $5, %eax
    je sair
    call opcao_invalida
    jmp mostrar_menu

preencher_matriz:
    # Leitura do número de linhas
    pushl $entrada_linhas
    call printf
    addl $4, %esp

    movl $linhas, %eax
    pushl %eax
    pushl $input_valor
    call scanf
    addl $8, %esp

    # Leitura do número de colunas
    pushl $entrada_colunas
    call printf
    addl $4, %esp

    movl $colunas, %eax
    pushl %eax
    pushl $input_valor
    call scanf
    addl $8, %esp

    # Calcular o tamanho da matriz e alocar memória
    movl linhas, %eax
    imull colunas, %eax
    imull $4, %eax  # Multiplicar por 4 (tamanho de um inteiro)
    pushl %eax
    call malloc
    addl $4, %esp
    movl %eax, matriz  # Guardar o endereço da matriz alocada

    # Imprimindo as dimensões da matriz
    pushl colunas
    pushl linhas
    pushl $entrada
    call printf
    addl $12, %esp

    # Preenchendo a matriz
    movl $0, %esi  # i = 0
preencher_linhas:
    cmpl linhas, %esi
    jge imprimir_matriz  # Se i >= linhas, sai do loop

    movl $0, %edi  # j = 0
preencher_colunas:
    cmpl colunas, %edi
    jge incrementar_linha  # Se j >= colunas, vai para próxima linha

    pushl %edi  # Passa j
    pushl %esi  # Passa i
    pushl $fill  # Mensagem de preenchimento
    call printf
    addl $12, %esp

    movl $val_temp, %eax  # Carrega o endereço de 'val_temp'
    pushl %eax            # Passa o endereço
    pushl $input_valor
    call scanf
    addl $8, %esp

    # Depuração: Imprimir o valor lido
    movl val_temp, %eax
    pushl %eax
    pushl $debug_msg
    call printf
    addl $8, %esp

    # Armazenar na matriz
    movl val_temp, %edx  # Carrega o valor lido de val_temp
    movl %esi, %eax      # i
    imull colunas, %eax  # i * colunas
    addl %edi, %eax      # i * colunas + j
    imull $4, %eax       # Multiplicar por 4 para obter o deslocamento em bytes
    movl matriz, %ebx    # Carregar o endereço da matriz
    movl %edx, (%ebx, %eax)  # Armazena valor

    # Depuração: Imprimir a operação de armazenamento
    pushl %edx
    pushl %edi
    pushl %esi
    pushl $debug_store
    call printf
    addl $16, %esp

    incl %edi
    jmp preencher_colunas

incrementar_linha:
    incl %esi
    jmp preencher_linhas

imprimir_matriz:
    # Função para imprimir a matriz preenchida
    pushl colunas
    pushl linhas
    pushl $mostrar_matriz_msg
    call printf
    addl $12, %esp

    movl $0, %esi  # i = 0
imprimir_linhas:
    cmpl linhas, %esi
    jge voltar_menu  # Se i >= linhas, sai do loop

    movl $0, %edi  # j = 0
imprimir_colunas:
    cmpl colunas, %edi
    jge nova_linha  # Se j >= colunas, vai para próxima linha

    movl %esi, %eax      # i
    imull colunas, %eax  # i * colunas
    addl %edi, %eax      # i * colunas + j
    imull $4, %eax       # Multiplicar por 4 para obter o deslocamento em bytes
    movl matriz, %ebx    # Carregar o endereço da matriz
    movl (%ebx, %eax), %edx  # Carregar matriz[i][j]

    # Depuração: Imprimir o valor lido da matriz
    pushl %edx
    pushl %edi
    pushl %esi
    pushl $debug_matrix
    call printf
    addl $16, %esp

    pushl %edx           # Valor a ser impresso
    pushl $input_valor   # Formato
    call printf
    addl $8, %esp

    incl %edi
    jmp imprimir_colunas

nova_linha:
    pushl $nova_linhas
    call printf
    addl $4, %esp

    incl %esi
    jmp imprimir_linhas

voltar_menu:
    call mostrar_menu

buscar_elemento:
    pushl $buscar_linha
    call printf
    addl $4, %esp

    movl $linha_busca, %eax
    pushl %eax
    pushl $input_valor
    call scanf
    addl $8, %esp

    pushl $buscar_coluna
    call printf
    addl $4, %esp

    movl $coluna_busca, %eax
    pushl %eax
    pushl $input_valor
    call scanf
    addl $8, %esp

    # Buscar o elemento
    movl linha_busca, %esi
    movl coluna_busca, %edi

    movl %esi, %eax      # i
    imull colunas        # i * colunas
    addl %edi, %eax      # i * colunas + j
    imull $4, %eax       # Multiplicar por 4 para obter o deslocamento em bytes
    movl matriz, %ebx    # Carregar o endereço da matriz
    movl (%ebx, %eax), %edx  # Carregar matriz[i][j]

    pushl %edx           # Valor a ser impresso
    pushl $elemento_encontrado # Mensagem
    call printf
    addl $8, %esp

    call mostrar_menu

mostrar_diagonal:
    movl $0, %esi  # i = 0
imprimir_diagonal:
    cmpl linhas, %esi
    jge voltar_menu  # Se i >= linhas, sai do loop
    cmpl colunas, %esi
    jge voltar_menu  # Se i >= colunas, sai do loop

    movl %esi, %eax      # i
    imull colunas        # i * colunas
    addl %esi, %eax      # i * colunas + i
    imull $4, %eax       # Multiplicar por 4 para obter o deslocamento em bytes
    movl matriz, %ebx    # Carregar o endereço da matriz
    movl (%ebx, %eax), %edx  # Carregar matriz[i][i]

    pushl %edx           # Valor a ser impresso
    pushl $input_valor   # Formato
    call printf
    addl $8, %esp

    pushl $nova_linhas
    call printf
    addl $4, %esp

    incl %esi
    jmp imprimir_diagonal

mostrar_lucky_numbers:
    movl $0, %esi  # i = 0
verificar_linhas:
    cmpl linhas, %esi
    jge voltar_menu  # Se i >= linhas, sai do loop

    # Encontrar o menor elemento na linha i
    movl $0, %edi
    movl $2147483647, %ebx  # Inicializa com o maior valor de int

encontrar_menor_na_linha:
    cmpl colunas, %edi
    jge verificar_linha_atual

    movl %esi, %eax      # i
    imull colunas        # i * colunas
    addl %edi, %eax      # i * colunas + j
    imull $4, %eax       # Multiplicar por 4 para obter o deslocamento em bytes
    movl matriz, %ebx    # Carregar o endereço da matriz
    movl (%ebx, %eax), %edx  # Carregar matriz[i][j]

    cmpl %edx, %ebx
    jge continuar_linha
    movl %edx, %ebx      # Atualiza o menor elemento

continuar_linha:
    incl %edi
    jmp encontrar_menor_na_linha

verificar_linha_atual:
    # Verificar se o menor elemento na linha é o maior na coluna
    movl $0, %edi
verificar_coluna:
    cmpl linhas, %edi
    jge proxima_linha

    movl %edi, %eax      # j
    imull colunas        # j * colunas
    addl %esi, %eax      # j * colunas + i
    imull $4, %eax       # Multiplicar por 4 para obter o deslocamento em bytes
    movl matriz, %ebx    # Carregar o endereço da matriz
    movl (%ebx, %eax), %edx  # Carregar matriz[j][i]

    cmpl %ebx, %edx
    jge continuar_coluna
    jmp proxima_linha

continuar_coluna:
    incl %edi
    jmp verificar_coluna

proxima_linha:
    pushl %ebx           # Lucky number a ser impresso
    pushl $lucky_number_msg # Mensagem
    call printf
    addl $8, %esp

    incl %esi
    jmp verificar_linhas

sair:
    pushl $msg_sair
    call printf
    addl $4, %esp

    # Encerrar o programa
    movl $1, %eax       # syscall: exit
    movl $0, %ebx       # status 0
    int $0x80

opcao_invalida:
    pushl $opcao_invalidas
    call printf
    addl $4, %esp
    jmp mostrar_menu
