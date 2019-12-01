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

go_to_protected_mode:
        xor ax, ax
        mov ds, ax

        cli
        ;gdtr
        lgdt [gdtr]
        ;a20 gate
        in al, 0x93
        or al, 2
        and al, ~1
        out 0x92, al
        ;
        mov eax, cr0
        or eax, 1
        mov cr0, eax
        jmp (CODE_DESC - NULL_DESC) : run_kernel

;;;;;;;;;GDT;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;* Global Descriptor Table (GDT) *
;*********************************
NULL_DESC:
    dd 0            ; null descriptor
    dd 0

CODE_DESC:
    dw 0xFFFF       ; limit low
    dw 0            ; base low
    db 0            ; base middle
    db 10011010b    ; access
    db 11001111b    ; granularity
    db 0            ; base high

DATA_DESC:
    dw 0xFFFF       ; limit low
    dw 0            ; base low
    db 0            ; base middle
    db 10010010b    ; access
    db 11001111b    ; granularity
    db 0            ; base high

gdtr:
    Limit dw gdtr - NULL_DESC - 1 ; length of GDT
    Base dd NULL_DESC   ; base of GDT

CODE_SEG equ CODE_DESC - NULL_DESC

bits 32
run_kernel:
        mov ax, DATA_DESC - NULL_DESC
        mov ds, ax ; update data segment
        mov eax, CODE_SEG
        add eax, 0x0500
        jmp 0x0500

times   510-($-$$) db 0  
dw      0xaa55              
