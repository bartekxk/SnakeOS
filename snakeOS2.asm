%include "variables.inc"
;%include "functions.asm"
BITS 16
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;configuration;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start:
	mov ax, 07C0h
	add ax, 288
	mov ss, ax
	mov sp, 4096

	mov ax, 07C0h
	mov ds, ax

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;main;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	call _clear_screen
	call _load_board_strings
	mov si, 07E00h
	call _print_str
	add si, 82
	call _print_str

	jmp $			; infinite loop

;;;;;;;;;;;;;;;;;;;;;;;;functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;_clear_screen;;;;;;;;;;;;;;;;;;;;
_clear_screen:
	pusha
	mov cx,25
;;;;;;;;;;;;;
next_line_clear:
	mov si,next_line_str
	call _print_str
	dec cx
	cmp cx,0
	jne next_line_clear
	popa
	ret
;;;;;;;;;;;;;;;;_clear_screen;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;_print_str;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;EXAMPLE HOW TO USE;;;;
;;;	mov si, str;;;;
;;; call _print_str;;;;;

_print_str:
	pusha
	mov ah, 0Eh
repeat_ps1:
	lodsb
	cmp al, 0
	je done_ps1
	int 10h
	jmp repeat_ps1
	done_ps1:
	popa
	ret
;;;;;;;;;;;;;;;;;;;;;_print_str;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;_load_board_strings;;;;;;;;;;;;;;;;;;;;;;;;
_load_board_strings:
	pusha
	mov bx, 07E00h
	mov cx, 80
	mov ah, 'x'

repeat_lbs1:
	mov byte [bx],ah
	dec cx
	inc bx
	cmp cx,0
	jne repeat_lbs1

;;;;;;;;;;;;;;;;;;;;
	mov byte [bx],10
	mov byte [bx+1],0
	mov byte [bx+1],'x'
	mov cx, 78
	mov ah, ' '
repeat_lbs2:
	mov byte [bx],ah
	dec cx
	inc bx
	cmp cx,0
	jne repeat_lbs2

;;;;;;;;;;;;;;;;;;;;
	mov byte [bx+1],'x'
	mov byte [bx],10
	mov byte [bx+1],0

	popa
	ret	
;;;;;;;;;;;;;;;;;;;;;;;_load_board_strings;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;boot_signature;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	times 510-($-$$) db 0
	dw 0xAA55
