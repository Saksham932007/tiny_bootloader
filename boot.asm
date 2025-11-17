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