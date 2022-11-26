#ifndef CONFIG_H
#define CONFIG_H

// Selectors values **MUST** equal the values we have in kernel.asm
#define KERNEL_CODE_SELECTOR        0x08
#define KERNEL_DATA_SELECTOR        0x10

#define PEACHOS_TOTAL_INTERRUPTS    512 //0x200

#define PEACHOS_HEAP_SIZE_BYTES     104857600 // 100MB = 100 * 1024 * 1024
#define PEACHOS_HEAP_BLOCK_SIZE     4096
#define PEACHOS_HEAP_ADDRESS        0x01000000
#define PEACHOS_HEAP_TABLE_ADDRESS  0x00007E00

/** 
 * There are two main things that we want to map:
 * 1. kernel_heap_table.entries -> will be pointing at the total number of table entires.
 * 2. the actual data poll (heap) -> will be pointing at the whole data poll which is much greater in size than kernel heap table entries.
 *    
 * We only need (100MB / 4096) = (1024*1024*100/4096) = 25600 bytes for all table entries.
*/

#endif