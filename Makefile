.PHONY: all build run clean

C_FLAGS = -m32 -ffreestanding -nostdlib -nostdinc -c

all: build

kernel.o: kernel.c
	gcc $(C_FLAGS) kernel.c -o kernel.o

build:
	@echo "Building bootloader and kernel..."

run:
	@echo "Starting bochs..."
	bochs -f bochsrc.txt

clean:
	@echo "Cleaning up..."