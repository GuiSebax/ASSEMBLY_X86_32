.section .data
    inputstr: .string "%d %d"
    outputstr: .string "Triangle Area: (%d * %d) / %d = %d\n"
    infostr: .string "Insira os valores: '(base) (altura)': \n"
    formulastr: .string "Formula: a = [(b * h) / 2]\n"
    base: .long 0
    high: .long 0
    divisor: .long 2

.section .text
.global _start

_start:
    pushl $formulastr
    call printf
    pushl $infostr
    call printf
    addl $8, %esp

    pushl $base
    pushl $high
    pushl $inputstr
    call scanf
    addl $12, %esp
    
    movl $0, %edx
    movl base, %eax
    movl high, %ebx
    imul %ebx, %eax

    movl divisor, %ecx
    divl %ecx

    pushl %eax
    pushl divisor
    pushl base
    pushl high
    pushl $outputstr
    call printf

    pushl $0
    call exit