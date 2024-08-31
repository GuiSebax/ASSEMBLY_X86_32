.section .data
    text1: .asciz "Vetor original: %d, %d, %d\n"
    text2: .asciz "Vetor invertido: %d, %d, %d\n"
    v1: .int 5, 10, 20  # Vetor inicial com 3 elementos

.section .text
.globl _start

_start:
    # Mostra o vetor original
    movl $v1, %edi        # Carrega o endereço base do vetor v1 em %edi
    movl (%edi), %eax     # Carrega v1[0] em %eax
    movl 4(%edi), %ebx    # Carrega v1[1] em %ebx
    movl 8(%edi), %ecx    # Carrega v1[2] em %ecx

    pushl %ecx            # Prepara o terceiro elemento do vetor original para impressão
    pushl %ebx            # Prepara o segundo elemento do vetor original para impressão
    pushl %eax            # Prepara o primeiro elemento do vetor original para impressão
    pushl $text1          # Endereço da string formatada para impressão
    call printf           # Chama a função printf para imprimir o vetor original

    # Troca os valores do vetor v1[0] e v1[2]
    movl (%edi), %eax     # Carrega v1[0] em %eax
    movl 8(%edi), %ebx    # Carrega v1[2] em %ebx
    movl %ebx, (%edi)     # Coloca v1[2] na posição de v1[0]
    movl %eax, 8(%edi)    # Coloca v1[0] na posição de v1[2]

    # Mostra o vetor invertido
    movl $v1, %edi        # Carrega novamente o endereço base do vetor v1 em %edi
    movl (%edi), %eax     # Carrega v1[0] em %eax
    movl 4(%edi), %ebx    # Carrega v1[1] em %ebx
    movl 8(%edi), %ecx    # Carrega v1[2] em %ecx

    pushl %ecx            # Prepara o terceiro elemento do vetor invertido para impressão
    pushl %ebx            # Prepara o segundo elemento do vetor invertido para impressão
    pushl %eax            # Prepara o primeiro elemento do vetor invertido para impressão
    pushl $text2          
    call printf           

    # Saída do programa
    pushl $0             
    call exit              
