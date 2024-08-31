.data
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

.text
    .globl _start

_start:
    # Prompt for vector size
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
    ret

exit:
    movl $1, %eax        # syscall number for exit
    xor %ebx, %ebx       # exit status 0
    int $0x80            # make the system call
