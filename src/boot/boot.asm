ORG 0x7c00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0:step2

step2:
    cli 
    mov ax,  0
    mov ds, ax 
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti


.load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or al, 1
    mov cr0, eax
    ;jmp CODE_SEG:load32

; GDT - Global Descriptor Table
gdt_start:
; null segment, offset 0x0
gdt_null:
    dd 0x0
    dd 0x0
; code segment, offset 0x8
gdt_code: ;CS SHOULD POINT TO THIS 
    dw 0xffff ;Limit 0:15
    dw 0x0 ;Base 0:15
    db 0x0 ;Base 16:23
    db 0x9A ;Access Byte
    db 11001111b
    db 0 ;Base 24:31
; data segment, offset 0x10
gdt_data: ;DS, SS, ES, FS, GS
    dw 0xffff ;Limit 0:15
    dw 0x0 ;Base 0:15
    db 0x0 ;Base 16:23
    db 0x92 ;Access Byte
    db 11001111b
    db 0 ;Base 24:31
gdt_end: ; for calculating the size

gdt_descriptor:
    dw gdt_end - gdt_start -1 ; Size - determined by GDTR definions on OSDEV forum. Word length - also determined by OSDEV.
    dd gdt_start ; Offset  - Double word length - determined by OSDEV.

times 510-($ -$$) db 0

dw 0xAA55