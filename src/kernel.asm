[BITS 32]
global _start
extern kernel_main
CODE_SEG equ 0x08
DATA_SEG equ 0x10

_start:
    ;PROTECTED MODE - can't access BIOS anymore.
    ; can't access for example DISK as we did via BIOS.
    ; need to write our own disk driver to load rest of the kernel.
    ; BIOS only loads first sector (512 first bytes). for any program bigger than 512bytes we'll need DISK for that.
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax ; stack segment - usually stores information about the stack of the current program
    mov ebp, 0x00200000 ;base pointer
    mov esp, ebp ;stack pointer

    ;enabling A20 line
    in al, 0x92
    or al, 2
    out 0x92, al

    call kernel_main

    jmp $

    times 512-($ -$$) db 0