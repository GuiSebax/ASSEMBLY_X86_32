.section .data
    format_in: .asciz "%d"
    format_out: .asciz "Sua entrada: %d\n"
    num: .long 0

.section .text
.global _start

_start:
    pushl $num
    pushl $format_in
    call scanf
    addl $8, %esp

    pushl num 
    pushl $format_out
    call printf
    addl $8, %esp

    pushl $0
    call exit

    