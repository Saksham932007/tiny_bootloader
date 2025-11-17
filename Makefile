.PHONY: all build run clean

C_FLAGS = -m32 -ffreestanding -nostdlib -nostdinc -c

all: build

kernel.o: kernel.c
	gcc $(C_FLAGS) kernel.c -o kernel.o

kernel.bin: kernel.o
	ld -m elf_i386 -T linker.ld -o kernel.bin kernel.o --oformat=binary

boot.com: boot.asm
	nasm -f bin boot.asm -o boot.com

build: boot.com kernel.bin
	@echo "Building bootloader and kernel..."

run:
	@echo "Starting bochs..."
	bochs -f bochsrc.txt

clean:
	@echo "Cleaning up..."