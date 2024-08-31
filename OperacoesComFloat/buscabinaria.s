.section .data
    vetor: .double 1.0, 2.6, 3.0, 4.3, 5.0, 6.0, 7.3, 8.1, 9.0, 10.0
    toSearch: .space 8
    tam: .int 10
    format_scanf_float:    .asciz "%lf"
    format_printf_found:   .asciz "Elemento encontrado!\n"
    format_printf_notfound:.asciz "Elemento não encontrado!\n"
    format_printf_search:  .asciz "Digite o valor a ser buscado: "

.section .text
    .globl _start

_start:
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

    # Call the binary search function
    call binary_search

    # Exit program
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

# Binary search function
binary_search:
    # Initialize loop variables
    subl $1, %esi         # upper bound = tam - 1

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
    ret

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
    ret
