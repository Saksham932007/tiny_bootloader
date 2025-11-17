# Advanced Bootloader: 16-bit to 32-bit C Kernel

A sophisticated two-stage bootloader system that demonstrates the transition from 16-bit real mode to 32-bit protected mode, culminating in a C kernel execution.

## 🚀 Overview

This project implements a complete bootloader chain consisting of:

1. **Stage 1 (boot.asm)**: A 512-byte bootloader written in 16-bit assembly that:
   - Loads the kernel from disk sector 2
   - Sets up the Global Descriptor Table (GDT)
   - Switches the CPU to 32-bit protected mode
   - Transfers control to the C kernel

2. **Stage 2 (kernel.c)**: A simple 32-bit kernel written in C that:
   - Runs in protected mode
   - Prints messages directly to VGA video memory
   - Demonstrates successful mode transition

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   BIOS Boot     │    │  16-bit Assembly │    │   32-bit C      │
│   (Real Mode)   │───▶│   Bootloader     │───▶│    Kernel       │
│                 │    │  (boot.asm)      │    │  (kernel.c)     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
      Sector 1              Sector 1              Sector 2+
```

## ⚙️ Technical Features

### Bootloader Capabilities
- **Disk I/O**: BIOS interrupt 13h for reading kernel from disk
- **Error Handling**: Comprehensive disk read error detection
- **Memory Management**: Strategic placement at 0x7C00 with kernel loading at 0x1000
- **Mode Switching**: Complete 16-bit to 32-bit protected mode transition

### Protected Mode Setup
- **GDT Configuration**: Properly configured Global Descriptor Table with code and data segments
- **Memory Layout**: 4GB flat memory model for both code and data
- **Register Setup**: Full segment register initialization for 32-bit operation
- **Stack Management**: 32-bit stack pointer at 0x90000

### C Kernel Features
- **Direct VGA Access**: Text mode output at 0xB8000
- **Protected Mode**: Runs entirely in 32-bit protected mode
- **Custom Linking**: Uses custom linker script for precise memory placement

## 📁 Project Structure

```
tiny_bootloader/
├── boot.asm          # 16-bit assembly bootloader
├── kernel.c          # 32-bit C kernel
├── linker.ld         # Custom linker script
├── Makefile          # Build automation
├── bochsrc.txt       # Bochs emulator configuration
├── .gitignore        # Git ignore patterns
└── README.md         # This file
```

## 🛠️ Prerequisites

- **nasm**: Netwide Assembler for assembly compilation
- **gcc**: GNU Compiler Collection with 32-bit support
- **ld**: GNU Linker (part of binutils)
- **bochs**: PC emulator for testing bootloader

### Installation (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install nasm gcc binutils bochs bochs-x
```

### Installation (macOS)
```bash
brew install nasm gcc bochs
```

## 🚀 Building and Running

### Build the System
```bash
make all
```
This creates:
- `boot.com` - Compiled bootloader
- `kernel.bin` - Linked C kernel
- `image.img` - Complete disk image

### Run in Emulator
```bash
make run
```
Launches the bootloader in Bochs emulator.

### Clean Build Artifacts
```bash
make clean
```
Removes all generated files.

## 🔧 Build Process Details

1. **Assembly Compilation**: `boot.asm` → `boot.com` (512 bytes, bootable)
2. **C Compilation**: `kernel.c` → `kernel.o` (32-bit object file)
3. **Kernel Linking**: `kernel.o` → `kernel.bin` (flat binary at 0x1000)
4. **Image Creation**: `boot.com` + `kernel.bin` → `image.img`

## 📋 Memory Layout

```
0x00000000 - 0x000003FF: Interrupt Vector Table
0x00000400 - 0x000004FF: BIOS Data Area
0x00000500 - 0x00007BFF: Free conventional memory
0x00007C00 - 0x00007DFF: Bootloader (boot.asm)
0x00007E00 - 0x00000FFF: Free memory
0x00001000 - 0x????????: Kernel (kernel.c)
0x00090000: 32-bit Stack
```

## 🎯 Learning Objectives

This project demonstrates:
- **Low-level system programming** in assembly and C
- **Boot process understanding** from BIOS to kernel
- **Memory management** and segmentation
- **Mode transitions** between 16-bit and 32-bit modes
- **Custom linking** and memory layout control
- **Hardware interface** programming (VGA, disk I/O)

## 🐛 Troubleshooting

### Common Issues

**"Disk read error!"**
- Ensure image.img is properly created
- Check Bochs configuration in bochsrc.txt

**Kernel not executing**
- Verify linker script places kernel at 0x1000
- Check GDT setup and protected mode transition

**Build failures**
- Ensure all prerequisites are installed
- Check gcc 32-bit support: `gcc -m32 --version`

## 🤝 Contributing

This is an educational project. Feel free to:
- Experiment with different kernel features
- Add support for other emulators (QEMU, VirtualBox)
- Implement additional bootloader stages
- Enhance error handling and diagnostics

## 📜 License

This project is for educational purposes. Feel free to use and modify as needed.

---

**Note**: This bootloader is designed for learning purposes and should not be used in production systems without significant security enhancements.