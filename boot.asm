bits 16
org 0x7C00

cli

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

times 510-($-$$) db 0
dw 0xAA55