.PHONY: all build run clean

all: build

build:
	@echo "Building bootloader and kernel..."

run:
	@echo "Starting bochs..."
	bochs -f bochsrc.txt

clean:
	@echo "Cleaning up..."