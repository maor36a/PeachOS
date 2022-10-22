#ifndef IDT_H
#define IDT_H

#include <stdint.h>
#include "kernel.h"


// the location of the IDT is kept in the IDTR
// this is loaded by LIDT asm instruction, whose argument is a pointer to an IDT descriptor structure
typedef struct __attribute__((packed)) Idtr_desc  {
    uint16_t limit;     // size of the
    uint32_t base;      // pointer to the idt
} idtr_desc;

typedef struct __attribute__((packed)) Idt_desc {
    uint16_t offset_1;       // offset bits 0-15
    uint16_t selector;      // selector that's in our gdt
    uint8_t zero;           // unused, set to 0
    uint8_t type_attr;      // descriptor types and attributes
    uint16_t offset_2;       // offset bits 16-31
} idt_desc;

void idt_init();

#endif