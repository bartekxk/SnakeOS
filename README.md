# SnakeOS
Snake operation system.

## Target
Implementation of simple operating system including Snake Game (https://en.wikipedia.org/wiki/Snake_(video_game_genre)) but the main target was learn how to create operating system with segmentation.

## Implementation
In this project, I implemented my OS in two languages (Asm - NASM and C). I decided to change project roadmap, I rewrite kernel from Asm to C after problems with creation of GDT tables. OS without segmentation on Asm is still working but if you want to do this and jump into 32-bit mode you have to (of course in this project) use kernel in C.

## Bootloader
Firstly bootloader have to read my kernel (4 sectors) from drive, create GDT tables and next jump into protected mode. 

## Kernel

Kernel include a few methods to handle video and keyboard. I created a simple interface and our target - Snake.

## Kernel in Assembly

Kernel in Assembly provides one more functionality - notepad (at now without possibility to save and read document). I deleted it in C due to change a method of keyboard handle. At now we are not using a bios functions but orders to read a ports.

## Build

To build my system on qemu i wrote the simple script - build.sh.
To burn system on for example pendrive we can use burnUSB.sh shell script.
