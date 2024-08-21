# Nome do arquivo assembly
ASM_FILE := main.s

# Nome do arquivo objeto gerado
OBJ_FILE := obj.o

# Nome do executável gerado
EXEC_FILE := exec

# Opções de compilação e linkagem
ASM_FLAGS := -32
GDB_FLAGS := -gstabs -32
LD_FLAGS := -m elf_i386 -lc -dynamic-linker /lib/ld-linux.so.2

# Alvo padrão
.DEFAULT_GOAL := all

# Alvo para criar o código objeto
build: $(OBJ_FILE)

$(OBJ_FILE): $(ASM_FILE)
	as $(ASM_FLAGS) $(ASM_FILE) -o $(OBJ_FILE)

# Alvo para linkar e criar o executável
link: $(EXEC_FILE)

$(EXEC_FILE): $(OBJ_FILE)
	ld $(LD_FLAGS) $(OBJ_FILE) -o $(EXEC_FILE)

# Alvo para rodar o executável
run: $(EXEC_FILE)
	./$(EXEC_FILE)

# Alvo para criar o código objeto com suporte a GDB
build-gdb: 
	as -g $(GDB_FLAGS) $(ASM_FILE) -o $(OBJ_FILE)

# Alvo para rodar o executável no GDB
run-gdb: build-gdb link
	gdb ./$(EXEC_FILE)

# Alvo para limpar os arquivos gerados
clean:
	rm -f $(OBJ_FILE) $(EXEC_FILE)

# Alvo para realizar todas as etapas em sequência
all: build link run

# Alvo para mostrar ajuda
help:
	@echo "Alvos disponíveis:"
	@echo "  make            - Compila, linka e executa o código"
	@echo "  make build      - Cria o código objeto"
	@echo "  make link       - Realiza a linkagem e cria o executável"
	@echo "  make run        - Executa o código"
	@echo "  make build-gdb  - Cria o código objeto com suporte a GDB"
	@echo "  make run-gdb    - Executa o código no GDB"
	@echo "  make clean      - Limpa os arquivos gerados"
