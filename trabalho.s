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
buscar_elemento_msg: .string "Digite o elemento que queira buscar: "
elemento_encontrado: .string "Elemento %d encontrado na posição [%d][%d]\n"
elemento_n_encontrado: .string "Elemento %d não foi encontrado na matriz\n"
lucky_number_msg: .string "Lucky number encontrado: %d\n"
mostrar_matriz_msg: .string "Matriz (%d x %d):\n"
menor_linhas_msg: .string "Menor elemento da linha %d é %d\n"
maior_colunas_msg: .string "Maior elemento da coluna %d é %d\n"
matriz: .int 0  # Posição para armazenar o endereço da matriz
menor_valores: .space 4000  # Vetor para armazenar os menores valores das linhas
maior_valores: .space 4000  # Vetor para armazenar os maiores valores das colunas
opcao: .int 0
elemento_busca: .int 0
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

    # Armazenar na matriz
    movl val_temp, %edx  # Carrega o valor lido de val_temp
    movl %esi, %eax      # i
    imull colunas, %eax  # i * colunas
    addl %edi, %eax      # i * colunas + j
    imull $4, %eax       # Multiplicar por 4 para obter o deslocamento em bytes
    movl matriz, %ebx    # Carregar o endereço da matriz
    movl %edx, (%ebx, %eax)  # Armazena valor

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
    pushl $buscar_elemento_msg
    call printf
    addl $4, %esp

    movl $elemento_busca, %eax
    pushl %eax
    pushl $input_valor
    call scanf
    addl $8, %esp

    # Inicializar índices de busca
    movl $0, %esi  # i = 0
buscar_linhas:
    cmpl linhas, %esi
    jge elemento_n_encontrado  # Se i >= linhas, elemento não encontrado

    movl $0, %edi  # j = 0
buscar_colunas:
    cmpl colunas, %edi
    jge incrementar_linha_busca  # Se j >= colunas, vai para próxima linha

    movl %esi, %eax      # i
    imull colunas, %eax  # i * colunas
    addl %edi, %eax      # i * colunas + j
    shl $2, %eax         # Multiplicar por 4 para obter o deslocamento em bytes
    movl matriz, %ebx    # Carregar o endereço da matriz
    movl (%ebx, %eax), %ecx  # Carregar matriz[i][j]

    cmpl elemento_busca, %ecx
    jne continuar_busca

    # Elemento encontrado
    pushl %edi  # j
    pushl %esi  # i
    pushl elemento_busca  # elemento
    pushl $elemento_encontrado
    call printf
    addl $16, %esp
    jmp voltar_menu

continuar_busca:
    incl %edi
    jmp buscar_colunas

incrementar_linha_busca:
    incl %esi
    jmp buscar_linhas

elemento_nao_encontrado:
    pushl elemento_busca  # elemento
    pushl $elemento_n_encontrado
    call printf
    addl $8, %esp

    call voltar_menu

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
    # Inicializar os vetores de menores e maiores valores
    movl linhas, %eax
    shl $2, %eax          # Multiplicar por 4 (tamanho de um inteiro)
    movl $0, %esi         # i = 0
    lea menor_valores, %edi

    # Inicializar menor_valores com o maior valor possível
inicializar_menores:
    movl $2147483647, (%edi, %esi, 4)
    incl %esi
    cmpl linhas, %esi
    jl inicializar_menores

    movl colunas, %eax
    shl $2, %eax          # Multiplicar por 4 (tamanho de um inteiro)
    movl $0, %esi         # i = 0
    lea maior_valores, %edi

    # Inicializar maior_valores com o menor valor possível
inicializar_maiores:
    movl $-2147483648, (%edi, %esi, 4)
    incl %esi
    cmpl colunas, %esi
    jl inicializar_maiores

    # Encontrar o menor valor de cada linha
    movl $0, %esi  # i = 0
    movl linhas, %ebx
    movl matriz, %ecx
encontrar_menores:
    cmpl %ebx, %esi
    jge verificar_maiores  # Se i >= linhas, vai verificar os maiores

    movl $0, %edi  # j = 0
    lea menor_valores, %edx

encontrar_menor_na_linha:
    cmpl colunas, %edi
    jge armazenar_menor  # Se j >= colunas, armazena o menor valor da linha

    movl %esi, %eax      # i
    imull colunas, %eax  # i * colunas
    addl %edi, %eax      # i * colunas + j
    shl $2, %eax         # Multiplicar por 4 para obter o deslocamento em bytes
    movl matriz, %ebx    # Carregar o endereço da matriz
    movl (%ebx, %eax), %eax  # Carregar matriz[i][j]

    cmpl %eax, (%edx, %esi, 4)
    jge continuar_menor_na_linha
    movl %eax, (%edx, %esi, 4)  # Atualiza o menor elemento

continuar_menor_na_linha:
    incl %edi
    jmp encontrar_menor_na_linha

armazenar_menor:
    incl %esi
    jmp encontrar_menores

verificar_maiores:
    # Encontrar o maior valor de cada coluna
    movl $0, %esi  # j = 0
    movl colunas, %ebx
    movl matriz, %ecx
encontrar_maiores:
    cmpl %ebx, %esi
    jge verificar_lucky_numbers  # Se j >= colunas, vai verificar os lucky numbers

    movl $0, %edi  # i = 0
    lea maior_valores, %edx

encontrar_maior_na_coluna:
    cmpl linhas, %edi
    jge armazenar_maior  # Se i >= linhas, armazena o maior valor da coluna

    movl %edi, %eax      # i
    imull colunas, %eax  # i * colunas
    addl %esi, %eax      # i * colunas + j
    shl $2, %eax         # Multiplicar por 4 para obter o deslocamento em bytes
    movl matriz, %ebx    # Carregar o endereço da matriz
    movl (%ebx, %eax), %eax  # Carregar matriz[i][j]

    cmpl (%edx, %esi, 4), %eax
    jle continuar_maior_na_coluna
    movl %eax, (%edx, %esi, 4)  # Atualiza o maior elemento

continuar_maior_na_coluna:
    incl %edi
    jmp encontrar_maior_na_coluna

armazenar_maior:
    incl %esi
    jmp encontrar_maiores

verificar_lucky_numbers:
    # Verificar lucky numbers
    pushl $lucky_number_msg
    call printf
    addl $4, %esp

    movl $0, %esi  # i = 0
    movl linhas, %eax
    lea menor_valores, %ecx
    lea maior_valores, %edx
verificar_lucky_numbers_loop:
    cmpl %eax, %esi
    jge fim_lucky_numbers  # Se i >= linhas, sai do loop

    movl (%ecx, %esi, 4), %ebx  # Carregar menor_valores[i]
    movl $0, %edi  # j = 0

comparar_maior:
    cmpl colunas, %edi
    jge incrementar_linha_lucky  # Se j >= colunas, vai para próxima linha

    movl (%edx, %edi, 4), %eax  # Carregar maior_valores[j]
    cmpl %ebx, %eax
    jne continuar_comparar_maior

    # Lucky number encontrado
    pushl %ebx
    pushl $input_valor
    call printf
    addl $8, %esp

continuar_comparar_maior:
    incl %edi
    jmp comparar_maior

incrementar_linha_lucky:
    incl %esi
    jmp verificar_lucky_numbers_loop

fim_lucky_numbers:
    pushl $nova_linhas
    call printf
    addl $4, %esp

    jmp voltar_menu



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
