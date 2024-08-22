# Trabalho de PIHS
# Guilherme Frare Clemente - RA:124349
# Marcos Vinicius de Oliveira - RA:124408
.section .data
    # Mensagens e Formatos
    menu: .string "Menu:\n1 - Menores e Maiores\n2 - Busca Binária\n3 - Sair\nEscolha uma opção: "
    opcao: .int 0
    formatOpcao: .asciz "%d"
    msg_sair: .asciz "Saindo...."
    introMsg: .asciz "Maiores e Menores(Float)\n\n"
    promptNum: .asciz "Digite o número #%d: "
    formatInput: .asciz " %lf"
    promptPivo: .asciz "Digite o valor do pivô: "
    showPivo: .asciz "Pivô: %g\n"
    listStart: .asciz "["
    listFormat: .asciz " %g "
    listEnd: .asciz "]\n"
    fpuStackMsg:  .asciz "  Pilha do Float: "
    smallerListMsg: .asciz " Menores: "
    largerListMsg: .asciz "Maiores ou iguais: "
    stackOne: .space 64  # 8 * 8 bytes
    topStackOne: .long 0
    stackTwo: .space 64
    topStackTwo: .long 0
    stackThree: .space 64
    topStackThree: .long 0
    pivoValue: .space 8
    vetor: .space 160               # Reserve space for 20 doubles (8 bytes each)
    tam: .int 0                     # Placeholder for vector size
    message_tam: .asciz "Digite o tamanho do vetor: "
    message_vetor: .asciz "Digite o valor do vetor[%d]: "
    format_input: .asciz "%lf"
    format_output: .asciz "%lf "
    break_line: .asciz "\n"
    counter: .int 0
    i: .int 0
    j: .int 0
    min: .int 0
    toSearch: .space 8
    format_scanf_float:    .asciz "%lf"
    format_printf_found:   .asciz "Elemento encontrado!\n"
    format_printf_notfound:.asciz "Elemento não encontrado!\n"
    format_printf_search:  .asciz "Digite o valor a ser buscado: "
    

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
    pushl $formatOpcao
    call scanf
    addl $8, %esp

    movl opcao, %eax
    cmpl $1, %eax
    je menores_maiores
    cmpl $2, %eax
    je ordenacao
    cmpl $3, %eax
    je sair
    jmp mostrar_menu

menores_maiores:
    pushl $introMsg
    call printf
    addl $4, %esp

    call readNumbers

    call transferFPUtoStackOne
    
    pushl $fpuStackMsg
    call printf
    addl $4, %esp
    
    call displayStackOne

    call readPivo
    call filterNumbers

    pushl $smallerListMsg
    call printf
    addl $4, %esp

    call displayStackTwo

    pushl $largerListMsg
    call printf
    addl $4, %esp

    call displayStackThree

    pushl $0
    call exit

readNumbers:
    movl $0, %edi
readNumbers_start:
    cmpl $8, %edi
    jge readNumbers_end

        movl %edi, %eax
        incl %eax
        pushl %eax
        pushl $promptNum
        call printf
        addl $8, %esp

        subl $8, %esp
        pushl %esp
        pushl $formatInput
        call scanf
        addl $8, %esp
        fldl (%esp)
        addl $8, %esp

    incl %edi
    jmp readNumbers_start
readNumbers_end:
    ret

readPivo:
    pushl $promptPivo
    call printf
    addl $4, %esp

    subl $8, %esp
    pushl %esp
    pushl $formatInput
    call scanf
    addl $8, %esp
    
    movl (%esp), %eax
    movl %eax, pivoValue
    movl 4(%esp), %eax
    movl %eax, 4 + pivoValue
    addl $8, %esp

    ret

transferFPUtoStackOne:
    # Desempilha valores da FPU para a pilha 1
    movl $0, %edi
transferFPUtoStackOne_start:
    cmpl $8, %edi
    jge transferFPUtoStackOne_end

        call pushStackOne

    incl %edi
    jmp transferFPUtoStackOne_start
transferFPUtoStackOne_end:
    ret

transferStackOneToFPU:
    # Reempilha valores da pilha 1 para a FPU
    movl $0, %edi
transferStackOneToFPU_start:
    cmpl $8, %edi
    jge transferStackOneToFPU_end

        call popStackOne

    incl %edi
    jmp transferStackOneToFPU_start
transferStackOneToFPU_end:
    ret

displayStackOne:
    # Exibe os valores da pilha 1
    pushl $listStart
    call printf
    addl $4, %esp

    # Imprime os números com printf
    movl $0, %edi
displayStackOne_start:
    cmpl topStackOne, %edi
    jge displayStackOne_end
        movl %edi, %eax
        imul $8, %eax
        addl $stackOne, %eax

        pushl 4(%eax)
        pushl (%eax)
        pushl $listFormat
        call printf
        addl $12, %esp
    incl %edi
    jmp displayStackOne_start
displayStackOne_end:

    pushl $listEnd
    call printf
    addl $4, %esp

    ret

displayStackTwo:
    # Exibe os valores da pilha 2
    pushl $listStart
    call printf
    addl $4, %esp

    # Imprime os números com printf
    movl $0, %edi
displayStackTwo_start:
    cmpl topStackTwo, %edi
    jge displayStackTwo_end
        movl %edi, %eax
        imul $8, %eax
        addl $stackTwo, %eax

        pushl 4(%eax)
        pushl (%eax)
        pushl $listFormat
        call printf
        addl $12, %esp
    incl %edi
    jmp displayStackTwo_start
displayStackTwo_end:

    pushl $listEnd
    call printf
    addl $4, %esp

    ret

displayStackThree:
    # Exibe os valores da pilha 3
    pushl $listStart
    call printf
    addl $4, %esp

    # Imprime os números com printf
    movl $0, %edi
displayStackThree_start:
    cmpl topStackThree, %edi
    jge displayStackThree_end
        movl %edi, %eax
        imul $8, %eax
        addl $stackThree, %eax

        pushl 4(%eax)
        pushl (%eax)
        pushl $listFormat
        call printf
        addl $12, %esp
    incl %edi
    jmp displayStackThree_start
displayStackThree_end:

    pushl $listEnd
    call printf
    addl $4, %esp

    ret

filterNumbers:
    # Filtra os números comparando com o pivô
    fldl pivoValue

    movl $0, %edi
filterNumbers_start:
    cmpl $8, %edi
    jge filterNumbers_end

        call popStackOne
        fcomi %st(1)
        
        jae filterNumbers_greater_eq
        call pushStackTwo
        jmp filterNumbers_inc
filterNumbers_greater_eq:
        call pushStackThree

filterNumbers_inc:
    incl %edi
    jmp filterNumbers_start
filterNumbers_end:
    ret

pushStackOne:
    # Empilha o valor da FPU na pilha 1
    movl topStackOne, %eax
    movl $stackOne, %ebx
    leal (%ebx, %eax, 8), %eax
    fstpl (%eax)
    incl topStackOne
    ret

popStackOne:
    # Desempilha o valor da pilha 1 para a FPU
    movl topStackOne, %eax
    subl $1, %eax
    movl $stackOne, %ebx
    leal (%ebx, %eax, 8), %eax
    fldl (%eax)
    decl topStackOne
    ret

pushStackTwo:
    # Empilha o valor da FPU na pilha 2
    movl topStackTwo, %eax
    movl $stackTwo, %ebx
    leal (%ebx, %eax, 8), %eax
    fstpl (%eax)
    incl topStackTwo
    ret

popStackTwo:
    # Desempilha o valor da pilha 2 para a FPU
    movl topStackTwo, %eax
    subl $1, %eax
    movl $stackTwo, %ebx
    leal (%ebx, %eax, 8), %eax
    fldl (%eax)
    decl topStackTwo
    ret

pushStackThree:
    # Empilha o valor da FPU na pilha 3
    movl topStackThree, %eax
    movl $stackThree, %ebx
    leal (%ebx, %eax, 8), %eax
    fstpl (%eax)
    incl topStackThree
    ret

popStackThree:
    # Desempilha o valor da pilha 3 para a FPU
    movl topStackThree, %eax
    subl $1, %eax
    movl $stackThree, %ebx
    leal (%ebx, %eax, 8), %eax
    fldl (%eax)
    decl topStackThree
    ret


ordenacao:
    pushl $message_tam
    call printf
    addl $4, %esp

    # Read vector size from the user
    pushl $tam
    pushl $format_input
    call scanf
    addl $8, %esp

    # Convert tam from float to integer
    fldl tam
    fistpl tam
    
    # Initialize i = 0
    movl $0, i

    # Read float numbers into vetor
    movl tam, %esi
    call read_vetor

    # Sort the vector using selection sort
    movl $0, i
    call selection_sort

    # Print the sorted vector
    movl $0, i
    call print_vetor

    # Exit program
    movl $1, %edi
    call exit

read_vetor:
    # Initialize counter to 0
    movl $0, counter

    # Loop to read tam float numbers into vetor
read_vetor_loop:
    movl counter, %edi
    cmpl tam, %edi
    jge end_read_vetor

    # Prompt for vetor[i]
    pushl %edi
    pushl $message_vetor
    call printf
    addl $4, %esp
    popl %edi

    # Read float value into vetor[i]
    leal vetor(,%edi,8), %eax
    pushl %eax
    pushl $format_input
    call scanf
    addl $8, %esp

    # Increment counter
    movl counter, %edi
    addl $1, %edi
    movl %edi, counter
    jmp read_vetor_loop

end_read_vetor:
    ret

selection_sort:
    # Initialize i = 0
    movl $0, i

selection_sort_loop:
    # if i >= tam - 1
    movl tam, %esi
    movl i, %edi
    cmpl %esi, %edi
    jge end_selection_sort

    # j = i + 1
    movl i, %eax
    addl $1, %eax
    movl %eax, j

    # min = i
    movl i, %eax
    movl %eax, min

    # while j < tam
while_j:
    movl j, %ecx
    cmpl %esi, %ecx
    jge end_while_j

    # Compare vetor[j] and vetor[min]
    fldl vetor(,%ecx,8)            # Load vetor[j] into FPU
    movl min, %ebx
    fldl vetor(,%ebx,8)            # Load vetor[min] into FPU
    fcomip %st(1), %st(0)          # Compare st(0) (vetor[min]) with st(1) (vetor[j])
    fstp %st(0)                    # Pop the comparison result to clean up the FPU stack
    jb end_if

    # min = j
    movl j, %eax
    movl %eax, min

end_if:
    # j = j + 1
    addl $1, j
    jmp while_j

end_while_j:
    # if min != i
    movl min, %ebx
    movl i, %edi
    cmpl %ebx, %edi
    je end_if2

    # Swap vetor[i] and vetor[min]
    leal vetor(,%edi,8), %eax      # Load address of vetor[i] into %eax
    leal vetor(,%ebx,8), %edx      # Load address of vetor[min] into %edx
    fldl (%eax)                    # Load vetor[i] into FPU
    fldl (%edx)                    # Load vetor[min] into FPU
    fstpl (%eax)                   # Store vetor[min] into vetor[i]
    fstpl (%edx)                   # Store vetor[i] into vetor[min]

end_if2:
    # i = i + 1
    movl i, %edi
    addl $1, %edi
    movl %edi, i
    jmp selection_sort_loop

end_selection_sort:
    ret

print_vetor:
    # Loop to print all elements in vetor
    movl $0, i
    movl tam, %esi
    finit
print_vetor_aux:
    movl i, %edi
    cmpl %esi, %edi
    jge end_print_vetor

    # Print vetor[i]
    leal vetor(,%edi,8), %eax  # Load address of vetor[i] into %eax
    fldl (%eax)                # Load double value from vetor[i] into FPU
    subl $8, %esp              # Allocate space on stack for format string and double value
    fstpl (%esp)               # Store double value on stack
    pushl $format_output       # Store address of format string on stack
    call printf
    addl $12, %esp             # Clean up the stack after printf call

    # Increment index i
    addl $1, i
    jmp print_vetor_aux

end_print_vetor:
    pushl $break_line
    call printf
    addl $4, %esp
    call busca_binaria

busca_binaria:
    # Prompt for the value to be searched
    pushl $format_printf_search
    call printf
    addl $4, %esp

    # Read the value to be searched
    pushl $toSearch
    pushl $format_scanf_float
    call scanf
    addl $8, %esp

    # Initialize the lower (eax) and upper (esi) bounds
    movl $0, %eax         # lower bound = 0
    movl tam, %esi        # upper bound = tam
    subl $1, %esi         # upper bound = tam - 1

    # Call the binary search function
    call binary_search_loop

binary_search_loop:
    cmpl %esi, %eax       # if lower bound > upper bound
    jg binary_search_notfound

    # Calculate the middle index
    movl %eax, %edx       # mid = (lower + upper) / 2
    addl %esi, %edx
    sarl $1, %edx

    # Load the middle value
    leal vetor(,%edx,8), %ecx
    fldl (%ecx)           # Load vetor[mid] into FPU

    # Compare the middle value with the value to be searched
    fldl toSearch         # Load toSearch into FPU
    fcomip %st(1), %st(0) # Compare st(0) (toSearch) with st(1) (vetor[mid])
    fstp %st(0)           # Pop FPU stack to remove the comparison result

    # Jump based on the comparison result
    je binary_search_found  # If equal, found
    jb binary_search_lower  # If toSearch < vetor[mid], search lower half
    ja binary_search_higher # If toSearch > vetor[mid], search upper half

binary_search_found:
    # Print the message
    pushl $format_printf_found
    call printf
    addl $4, %esp

    # Exit the function
    jmp busca_binaria

binary_search_lower:
    # Set the upper bound to mid - 1
    movl %edx, %esi
    subl $1, %esi
    jmp binary_search_loop

binary_search_higher:
    # Set the lower bound to mid + 1
    movl %edx, %eax
    addl $1, %eax
    jmp binary_search_loop

binary_search_notfound:
    # Print the message
    pushl $format_printf_notfound
    call printf
    addl $4, %esp

    # Exit the function
    jmp busca_binaria

sair:
    pushl $msg_sair
    call printf
    addl $4, %esp

    movl $1, %eax
    movl $0, %ebx
    int $0x80
