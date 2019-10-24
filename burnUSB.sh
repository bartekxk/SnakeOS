dd if=bootloader.bin of=$1 bs=512 count=1
dd if=kernel.bin of=$1 bs=512 count=8 seek=1
