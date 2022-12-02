section .asm

extern init21h_handler
extern no_interrupt_handler

global idt_load
global init21h
global no_interrupt
global enable_interrupts
global disable_interrupts

enable_interrupts:
    sti
    ret

disable_interrupts:
    cli
    ret

idt_load:
    push ebp
    mov ebp, esp

    mov ebx, [ebp+8] ;ebp = stack pointer, ebp+4 = ret address, ebp+8 = pointer we received as the 1st argument
    lidt[ebx]

    pop ebp
    ret

init21h:
    cli
    pushad
    call init21h_handler
    popad
    sti
    ret

no_interrupt:
    cli
    pushad
    call no_interrupt_handler
    popad
    sti
    ret