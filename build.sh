rm snakeOS.flp
nasm -f bin -o kernel.bin kernel.asm
nasm -f bin -o bootloader.bin bootloader.asm
dd if=bootloader.bin of=snakeOS.flp bs=512 count=1
gcc -ffreestanding -Wimplicit-function-declaration -fno-pie -ffreestanding -c new_kernel.c -o new_kernel.o -m32
ld -o new_kernel.bin -Ttext 0x0500 --oformat binary new_kernel.o -melf_i386
#dd if=kernel.bin of=snakeOS.flp bs=512 count=8 seek=1
dd if=new_kernel.bin of=snakeOS.flp bs=512 count=8 seek=1
qemu-system-i386 -fda snakeOS.flp
mkisofs -o snakeOS.iso -b snakeOS.flp .
