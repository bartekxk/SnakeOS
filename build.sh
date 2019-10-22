rm snakeOS.flp
nasm -f bin -o kernel.bin kernel.asm
nasm -f bin -o bootloader.bin bootloader.asm
dd if=bootloader.bin of=snakeOS.flp bs=512 count=1
dd if=kernel.bin of=snakeOS.flp bs=512 count=8 seek=1
qemu-system-i386 -fda snakeOS.flp
mkisofs -o snakeOS.iso -b snakeOS.flp .
