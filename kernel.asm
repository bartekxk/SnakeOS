BITS 16
org 0x0000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;							;;;
;;;			SnakeOS			;;;
;;;							;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;main;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text
config:
    mov ax, cs
    mov ds, ax 
main:
	call _menu
	jmp $
_menu:
	pusha
repeat_m1:	
	call _clear_screen
	call _random
	mov si, title
	call _print_str
	mov si,option1
	call _print_str
	mov si,option2
	call _print_str
	mov cx, 21
	call _draw_empy_lines
	call _get_key
	cmp ah,2h
	je case_m1
	cmp ah,3h
	je case_m2
	jmp repeat_m1
case_m1:
	call _apps
	jmp repeat_m1
case_m2:
	call _shutdown
	jmp repeat_m1

	popa
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;_menu;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;_apps;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_apps:
	pusha
repeat_a1:
	call _clear_screen	
	mov si, app1
	call _print_str
	mov si,back
	call _print_str
	mov cx, 22
	call _draw_empy_lines
	call _get_key
	cmp ah,2h
	je case_a1
	cmp ah,30h
	je case_a2
	jmp repeat_a1

case_a1:
	call _game_snake
	jmp repeat_a1
case_a2:

	popa
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;_apps;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;_game_snake;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_game_snake:
	pusha
	call _load_strings_to_ram
	mov byte [snake_x], 40
	mov byte [snake_y], 12
repeat_gs1:
	call _clear_screen
	call _draw_board
	call _move_snake
	call _keyboard_game_support
	cmp ah, 01h
	je done_gs1
	jmp repeat_gs1			; infinite loop
done_gs1:
	popa
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;_game_snake;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
	mov cx, 25
	call _draw_empy_lines

	popa
	ret
;;;;;;;;;;;;;;;;_clear_screen;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;_random;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_random:
	pusha
	mov ax, 13
	push ax
	mov bx, sp
	int 0x80
	pop ax
	mov si,ax
	call _print_str
	popa
	ret
;;;;;;;;;;;;;;;_random;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;_draw_empy_lines;;;;;;;;;;;;;;;;;;;;;
_draw_empy_lines:
	pusha
repeat_del1:
	mov si, next_line_str
	call _print_str
	dec cx
	cmp cx,0
	jne repeat_del1
;;;;;;;;;;;;

	popa
	ret
;;;;;;;;;;;;;;_draw_empy_lines;;;;;;;;;;;;;;;;;;;;;;;
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
;;;;;;;;;;;;;;;;;;;;;_load_strings_to_ram;;;;;;;;;;;;;;;;;;;;;;;;
_load_strings_to_ram:
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
	add bx, 2
	mov cx, 80
	mov ah, ' '
repeat_lbs3:
	mov byte [bx],ah
	dec cx
	inc bx
	cmp cx,0
	jne repeat_lbs3

;;;;;;;;;;;;;;;;;
	mov byte [bx],0
	popa
	ret	
;;;;;;;;;;;;;;;;;;;;;;;_load_strings_to_ram;;;;;;;;;;;;;;;;;;;;;;;;;
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
	mov si, snake_legend
	call _print_str
	popa
	ret

;;;;;;;;;;;;;;;;;;;;;;;_draw_board;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;_get_key;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_get_key:
    mov ah,0          
    int 16h            ; Wait for key
	ret
;;;;;;;;;;;;;;;;;;;;;;;_get_key;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;_keyboard_game_support;;;;;;;
_keyboard_game_support:
	call _get_key
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
done_gt1:

	ret
;;;;;;;;;;;;;;;;;;;;;;;;_keyboard_game_support;;;;;;;;;;;;;;;
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
	;todo
	ret
;;;;;;;;;;;;;;;;;;;;;;;_shutdown;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;variables;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .data
	title db 'Snake Operating System',10,13,0
	option1 db 'Apps[1]',10,13,0
	option2 db 'Exit[2]',10,13,0
	app1 db 'Snake[1]',10,13,0
	back db 'Back[B]',10,13,0
	next_line_str db 10,13,0
	snake_x db 40
	snake_y db 12
	time db 0,0
	snake db 'o'
	snake_legend db 'Arrow keys, esc to exit.',0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;boot_signature;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	times 2048 - ($ - $$) db 0
