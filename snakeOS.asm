BITS 16
org 0x7C00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;							;;;
;;;			SnakeOS			;;;
;;;							;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;configuration;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start:
	mov ax, 07C0h
	add ax, 288
	mov ss, ax
	mov sp, 4096

	mov ax, 07C0h
	mov ds, ax

	mov ah, 42h
	int 13h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;main;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main:
	jmp load
	jmp _load_strings_to_ram
	call _menu
	jmp $
load:
  mov bx, 0x8000  ; segment
  mov es, bx
  mov bx, 0x0000  ; offset

  mov ah, 0x02  ; read function
  mov al, 0x03  ; sectors
  mov ch, 0x00  ; cylinder
  mov cl, 0x02  ; sector
  mov dh, 0x00  ; head
  mov dl, 0x00  ; drive
  int 0x13   ; disk int

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;boot_signature;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	times 510-($-$$) db 0
	dw 0xAA55

