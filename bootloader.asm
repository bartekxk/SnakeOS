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


switch_protected_mode:
    mov ax, 0
    mov ss, ax
    mov sp, 0xFFFC

    mov ax, 0
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:0x0500

gdt_start:

gdt_null:
    dd 0x0
    dd 0x0

gdt_code:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0

gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start


times   510-($-$$) db 0  
dw      0xaa55              
