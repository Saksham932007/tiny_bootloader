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

hlt

loading_msg db 'Loading 32-bit Kernel...', 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55