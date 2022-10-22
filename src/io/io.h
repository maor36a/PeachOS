#ifndef IO_H
#define IO_H

// reads a byte / word from the given port
unsigned char insb(unsigned short port);
unsigned short insw(unsigned short port);

// writes a byte / word to the given port
void outb(unsigned short port, unsigned char val);
void outw(unsigned short port, unsigned short val);

#endif