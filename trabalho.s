.section .data
linhas: .int 0
colunas: .int 0
entrada: .string "Preencha a matriz (%d x %d):\n"
entrada_linhas: .string "Digite o número de linhas da matriz: "
entrada_colunas: .string "Digite o número de colunas da matriz: "
input_valor: .string "%d"
fill: .string "Elemento [%d][%d]: "
val_temp: .int 0
matriz: .space 1600  # Espaço para armazenar a matriz (400 inteiros)
nova_linha: .string "\n"

.section .text
.globl _start

_start:
    # Leitura do número de linhas
    pushl $entrada_linhas
    call printf
    addl $4, %esp

    lea linhas, %eax
    pushl %eax
    pushl $input_valor
    call scanf
    addl $8, %esp

    # Leitura do número de colunas
    pushl $entrada_colunas
    call printf
    addl $4, %esp

    lea colunas, %eax
    pushl %eax
    pushl $input_valor
    call scanf
    addl $8, %esp

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

    lea val_temp, %eax  # Carrega o endereço de 'val_temp'
    pushl %eax          # Passa o endereço
    pushl $input_valor
    call scanf
    addl $8, %esp

    # Armazenar na matriz
    movl val_temp, %edx  # Carrega o valor lido de val_temp
    movl %esi, %eax      # i
    imull colunas        # i * colunas
    addl %edi, %eax      # i * colunas + j
    movl %edx, matriz(, %eax, 4)  # Armazena valor

    incl %edi
    jmp preencher_colunas

incrementar_linha:
    incl %esi
    jmp preencher_linhas

imprimir_matriz:
    movl $0, %esi  # i = 0
imprimir_linhas:
    cmpl linhas, %esi
    jge terminar  # Se i >= linhas, sai do loop

    movl $0, %edi  # j = 0
imprimir_colunas:
    cmpl colunas, %edi
    jge nova_linhas  # Se j >= colunas, vai para próxima linha

    # Carregar o valor da matriz
    movl %esi, %eax   # i
    imull colunas     # i * colunas
    addl %edi, %eax   # i * colunas + j
    movl matriz(, %eax, 4), %edx  # Carregar matriz[i][j]

    pushl %edx        # Valor a ser impresso
    pushl $input_valor # Formato
    call printf
    addl $8, %esp

    incl %edi
    jmp imprimir_colunas

nova_linhas:
    pushl $nova_linha
    call printf
    addl $4, %esp

    incl %esi
    jmp imprimir_linhas

terminar:
    # Encerrar o programa
    movl $1, %eax       # syscall: exit
    xor %ebx, %ebx      # status 0
    int $0x80
