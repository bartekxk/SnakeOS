#include "io.h"

void clear_screen()
{
    int i = 0;
    char * video_memory = (char *) 0xb8000;
    for(; i < 2000; i++)
    {
        *video_memory = ' ';
        video_memory+=2;
    }
    return;
}

void printf(char data[256])
{
    char * video_memory = (char *) 0xb8000;
    int i = 0;
    for(;; i++, video_memory += 2)
    {
        char x = data[i];
        if(x == '\0')
            break;
        *video_memory = x;
        *(video_memory + 1) = (char) 0x0F;
    }

    return;
}


void printf_xy(char data[256], int x, int y)
{
    char * video_memory = (char *) 0xb8000;
    video_memory += (x + (y * 80)) * 2;
    int i = 0;
    for(;; i++, video_memory += 2)
    {
        char x = data[i];
        if(x == '\0')
            break;
        *video_memory = x;
        *(video_memory + 1) = (char) 0x0F;
    }

    return;
}

void outb( unsigned short port, unsigned char val )
{
   asm volatile("outb %0, %1" : : "a"(val), "Nd"(port) );
}

static __inline char inb (unsigned short int port)
{
  char _v;

  __asm__ __volatile__ ("inb %w1,%0":"=a" (_v):"Nd" (port));
  return _v;
}

char get_scancode()
{
    char inputdata = inb(0x60);
    return inputdata;
}