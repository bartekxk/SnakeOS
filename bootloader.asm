[BITS 16]
org 0x7C00

read_kernel:

        mov ah, 2h ; Read sectors from floppy drive
        mov al, 8    ; Read 4 sector
        mov ch, 0    ; Cylinder 0
        mov cl, 2    ; Sector 2
        mov dh, 0    ; Head 0
        mov bx, 0x0500 
        mov es, bx   
        xor bx, bx   
        int 13h

        jmp 0x0500:0

times   510-($-$$) db 0  
dw      0xaa55              
