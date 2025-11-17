void kprint(const char* str) {
    char* vga = (char*)0xB8000;
    while(*str != 0) {
        *vga++ = *str++;
        *vga++ = 0x07; // white on black
    }
}

void kmain(void) {
    kprint("Hello from 32-bit C Kernel!");
    while(1);
}