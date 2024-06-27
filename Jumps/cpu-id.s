.section .data
    output: .ascii "O ID do fabricante eh 'xxxxxxxxxxxx'!\n"

.section .text
.global _start

_start:
    movl $0, %eax
    cpuid

    movl $output, %edi
    movl %ebx, 23(%edi)
    movl %edx, 27(%edi)
    movl %ecx, 31(%edi)

    movl $4, %eax
    movl $1, %ebx
    movl $output, %ecx
    movl $38, %edx
    int $0x80

    movl $1, %eax
    movl $0, %ebx
    int $0x80

