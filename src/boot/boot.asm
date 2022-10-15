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
    jmp CODE_SEG:load32

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

[BITS 32] ; loading our kernel to mem and jump to it. can't use bios anymore
load32:
    mov eax, 1
    mov ecx, 100
    mov edi, 0x0100000
    call ata_lba_read
    ;now we're done loading our kernel into memory
    jmp CODE_SEG:0x0100000

; @eax, LBA (logical block address of sector)
; @cl, number of sectors to read
; @edi, address of buffer to put data obtained from the disk 
ata_lba_read:
    mov ebx, eax, ; Backup the LBA
    ; Send the highest 8 bits of the lba to hard disk controller
    shr eax, 24
    or eax, 0xE0 ; Select the  master drive
    mov dx, 0x1F6
    out dx, al
    ; Finished sending the highest 8 bits of the lba

    ; Send the total sectors to read
    mov eax, ecx
    mov dx, 0x1F2
    out dx, al
    ; Finished sending the total sectors to read

    ; Send more bits of the LBA
    mov eax, ebx ; Restore the backup LBA
    mov dx, 0x1F3
    out dx, al
    ; Finished sending more bits of the LBA

    ; Send more bits of the LBA
    mov dx, 0x1F4
    mov eax, ebx ; Restore the backup LBA
    shr eax, 8
    out dx, al
    ; Finished sending more bits of the LBA

    ; Send upper 16 bits of the LBA
    mov dx, 0x1F5
    mov eax, ebx ; Restore the backup LBA
    shr eax, 16
    out dx, al
    ; Finished sending upper 16 bits of the LBA

    mov dx, 0x1f7
    mov al, 0x20
    out dx, al

    ; Read all sectors into memory
.next_sector:
    push ecx
    ; Checking if we need to read
.try_again:
    mov dx, 0x1f7
    in al, dx
    test al, 8
    jz .try_again

; We need to read 256 words at a time
    mov ecx, 256
    mov dx, 0x1F0
    rep insw
    pop ecx
    loop .next_sector
    ; End of reading sectors into memory
    ret

times 510-($ -$$) db 0

dw 0xAA55