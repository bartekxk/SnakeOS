rm snakeOS.flp functions.flp
nasm -f bin -o snakeOS.bin snakeOS.asm
nasm -f bin -o functions.bin functions.asm
dd if=snakeOS.bin of=snakeOS.flp conv=notrunc
dd if=functions.bin of=snakeOS.flp conv=notrunc bs=512 seek=2
qemu-system-i386 -fda snakeOS.flp
mkisofs -o snakeOS.iso -b snakeOS.flp .
