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
game:
	call _load_board_strings
	call _clear_screen
	call _draw_board
	call _move_snake
	call _get_key
	jmp game			; infinite loop

;;;;;;;;;;;;;;;;;;;;;;;;functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;_color;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;EXAMPLE HOW TO USE;;;;
;;;	mov bl, *color*;;;;
;;; mov dl, *x*;;;;;
;;; mov dh, *y*;;;;;
;;; mov cx, *string len (optional);;;
;;; call _color;;;;;
_color:
	pusha
	mov  ax, ds
	mov  es, ax
	mov  ah, 13h
	mov  bh, 0
	int  10h 

	popa
	ret
;;;;;;;;;;;;;;;;;;;;;;;;_color;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
	mov byte [bx],0
	mov byte [bx+1],'x'
	add bx, 2
	mov cx, 78
	mov ah, ' '
repeat_lbs2:
	mov byte [bx],ah
	dec cx
	inc bx
	cmp cx,0
	jne repeat_lbs2

;;;;;;;;;;;;;;;;;;;;
	mov byte [bx],'x'
	mov byte [bx+1],0

	popa
	ret	
;;;;;;;;;;;;;;;;;;;;;;;_load_board_strings;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;_draw_board;;;;;;;;;;;;;;;;;;;;;;;;;
_draw_board:
	pusha
	call _clear_screen
	mov si, 07E00h
	call _print_str
	add si, 81
	mov cx,22
repeat_db1:
	call _print_str
	dec cx
	cmp cx,0
	jne repeat_db1
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;
	sub si,81
	call _print_str

	popa
	ret

;;;;;;;;;;;;;;;;;;;;;;;_draw_board;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;_get_key;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_get_key:
	pusha
    mov ah,0          
    int 16h            ; Wait for key
	cmp ah,04Bh
	je left
    cmp ah,04Dh
	je right
	cmp ah,048h
	je up
	cmp ah,050h
	je down
	cmp ah,013h
	je restart
	cmp ah,01h
	je exit
	jmp done_gt1
left:
	sub byte [snake_x],1
    jmp done_gt1
right:
	add byte [snake_x],1
	jmp done_gt1
up:
	sub byte [snake_y],1
	jmp done_gt1
down:
	add byte [snake_y],1
restart:
;;;todo
	jmp done_gt1
exit:
	call _shutdown
done_gt1:
	popa
	ret
;;;;;;;;;;;;;;;;;;;;;;;_get_key;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;_move_snake;;;;;;;;;;;;;;;;;;;;;;;;;
_move_snake:
	pusha

	mov cx,1
	mov bp, snake
	mov ax, ds
	mov es, ax        
	mov ah, 13h        ;SERVICE TO DISPLAY STRING WITH COLOR.
	mov bh, 0          ;PAGE (ALWAYS ZERO).
	mov bl, 00010000b
	mov dl, [snake_x]  
	mov dh, [snake_y]  
	int 10h           ;BIOS SCREEN SERVICES.  

	popa
	ret
;;;;;;;;;;;;;;;;;;;;;;;_move_snake;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;_shutdown;;;;;;;;;;;;;;;;;;;;;;;;;;
_shutdown:
	#todo
	ret
;;;;;;;;;;;;;;;;;;;;;;;_shutdown;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;boot_signature;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	times 510-($-$$) db 0
	dw 0xAA55
