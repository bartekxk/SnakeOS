rm snakeOS.flp
nasm -f bin -o snakeOS.bin snakeOS.asm
dd status=noxfer conv=notrunc if=snakeOS.bin of=snakeOS.flp
qemu-system-i386 -fda snakeOS.flp
mkisofs -o snakeOS.iso -b snakeOS.flp .
