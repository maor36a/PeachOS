#ifndef CONFIG_H
#define CONFIG_H

// Selectors values **MUST** equal the values we have in kernel.asm
#define KERNEL_CODE_SELECTOR 0x08
#define KERNEL_DATA_SELECTOR 0x10

#define PEACHOS_TOTAL_INTERRUPTS 512 //0x200

#endif