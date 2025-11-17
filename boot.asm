bits 16
org 0x7C00

cli

; Setup stack
mov ax, 0x07C0
mov ds, ax
mov ss, ax
mov sp, 0x7C00

; Print loading message
mov si, loading_msg
call print

; Set up disk read parameters
mov ah, 0x02    ; read sectors
mov al, 1       ; read 1 sector
mov ch, 0       ; track 0
mov cl, 2       ; sector 2 (sector 1 is the bootloader)
mov dh, 0       ; head 0
mov dl, 0       ; drive 0 (floppy A)
mov bx, 0x1000  ; load to 0x1000
mov es, bx
mov bx, 0       ; es:bx = 0x1000:0x0000

; Read kernel from disk
int 0x13
jc disk_error

; Disable interrupts before mode switch
cli

; Load GDT
lgdt [gdt_pointer]

; Enable Protected Mode (set PE bit)
mov eax, cr0
or eax, 0x1
mov cr0, eax

; Perform long jump to flush CPU pipeline
jmp 0x08:protected_mode_start

; 32-bit Protected Mode Code
bits 32
protected_mode_start:
    ; Set up 32-bit segment registers
    mov ax, 0x10    ; 0x10 is the data segment offset from the GDT
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

; Print subroutine
print:
    mov ah, 0x0e
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
.done:
    ret

disk_error:
    mov si, disk_error_msg
    call print
    hlt

hlt

; Global Descriptor Table
gdt_start:
    ; Null Descriptor
    gdt_null:
        dd 0x0
        dd 0x0
    
    ; Code Segment Descriptor (32-bit, 4GB)
    gdt_code:
        dw 0xFFFF       ; limit (bits 0-15)
        dw 0x0000       ; base (bits 0-15)
        db 0x00         ; base (bits 16-23)
        db 10011010b    ; access byte
        db 11001111b    ; granularity byte
        db 0x00         ; base (bits 24-31)
    
    ; Data Segment Descriptor (32-bit, 4GB)
    gdt_data:
        dw 0xFFFF       ; limit (bits 0-15)
        dw 0x0000       ; base (bits 0-15)
        db 0x00         ; base (bits 16-23)
        db 10010010b    ; access byte
        db 11001111b    ; granularity byte
        db 0x00         ; base (bits 24-31)
gdt_end:

; GDT Pointer
gdt_pointer:
    dw gdt_end - gdt_start - 1  ; size
    dd gdt_start                ; offset

loading_msg db 'Loading 32-bit Kernel...', 13, 10, 0
disk_error_msg db 'Disk read error!', 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55