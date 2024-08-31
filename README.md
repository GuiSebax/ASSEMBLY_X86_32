# ASSEMBLY_X86_32
Nesse repositório tem consigo uma ampla variedade de algoritmos desenvolvidos
em assemblyX86 com a sintaxe -> x86 32-bit AT&T syntax

Dentro de cada pasta tem exercícios de operações numéricas, chamadas de sistema, vetores
matrizes e operações com Floats. Foi utilizado nesses algoritmos a biblioteca libc para 
as operações de leitura e escrita de valores 

Para compilar o código basta executar esses comandos
```
$as -32 <arquivo>.s -o <arquivo>.o
$ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -o <arquivo>.o <executavel> -lc
```
