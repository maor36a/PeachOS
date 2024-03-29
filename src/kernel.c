#include <stdint.h>
#include <stddef.h>
#include "kernel.h"
#include "idt/idt.h"
#include "io/io.h"
#include "memory/heap/kheap.h"
#include "memory/paging/paging.h"
#include "disk/disk.h"
#include "string/string.h"
#include "fs/pparser.h"
#include "disk/streamer.h"


uint16_t* video_mem = 0;

uint16_t terminal_row = 0;
uint16_t terminal_col = 0;

uint16_t terminal_make_char (char c, char color) {
    return (color << 8) | c;
}

void terminal_put_char(int x, int y, char c, char color) {
    video_mem[(y*VGA_WIDTH + x)] = terminal_make_char(c, color);
}
 
 void terminal_initialize() {
    terminal_row = 0;
    terminal_col = 0;
    video_mem = (uint16_t*)(0xB8000);
    for (int y=0; y<VGA_HEIGHT; y++) {
        for (int x=0; x<VGA_WIDTH; x++) {
            terminal_put_char(x, y, ' ', 0);
        }
    }
 }

 void terminal_writechar(char c, char color) {
    if (c == '\n') {
        terminal_row += 1;
        terminal_col = 0;
        return;
    }
    terminal_put_char(terminal_col, terminal_row, c, color);
    terminal_col += 1;
    if (terminal_col >= VGA_WIDTH) {
        terminal_col = 0;
        terminal_row += 1;
    }
 }

void print(const char *str) {
    if (str == NULL) return;
    size_t len = strlen(str);
    for (int i=0; i<len; i++) {
        terminal_writechar(str[i], 15);
    }
}

static struct paging_4gb_chunk *kernel_chunk = 0;

void kernel_main() {
    terminal_initialize();
    char* str = "Hello World!\n";
    print(str);

    // Initialize the heap
    kheap_init();

    // Search and initialize the disk
    disk_search_and_init();

    // Initialize the interrupt descriptor table
    idt_init();

    // Setup paging
    kernel_chunk = paging_new_4gb(PAGING_IS_WRITEABLE | PAGING_IS_PRESENT | PAGING_ACCESS_FROM_ALL);

    // Switch to kernel paging chunk
    paging_switch((paging_4gb_chunk_get_directory(kernel_chunk)));

    // Enable paging
    enable_paging();

    // Enable the system interrupts
    enable_interrupts();

    struct disk_stream *streamer = diskstreamer_new(0);
    diskstreamer_seek(streamer, 0x20a);
    unsigned char out = 0;
    diskstreamer_read(streamer, &out, 1);
    diskstreamer_close(streamer); 
}