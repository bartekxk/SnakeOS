BITS 16
org 0x7C00
read_kernel:
    mov si, 0x0

    mov ax, 0x1000   ; setting up the address to read into
    mov es, ax       ; moving the value in to es
    xor bx, bx       ; clearing bx
    mov ah, 0x02     ; floppy function
    mov al, 1        ; read 1 sector
    mov ch, 0        ; cylinder
    mov cl, 2        ; sector to read
    mov dh, 0        ; head number
    mov dl, 0        ; drive number

    int 0x13         ; BIOS Interrupt Call

    jc read_kernel
    jmp  0x1000:0 

times 510 - ($-$$) db 0
dw 0xAA55