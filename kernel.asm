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
	call _clear_screen
	call _draw_board
	mov word [apples_x], 0
	mov word [apples_x+2], 0
	mov word [apples_y], 0
	mov word [apples_x+2],0
	mov byte [snake_len],3
	sub sp,2002
	mov [snake_memory],sp
	add word [snake_memory],2
	mov si,[snake_memory]
	mov byte [si],40
	mov byte [si+1],12
	mov byte [si+2],40
	mov byte [si+3],13
	mov byte [si+4],40
	mov byte [si+5],14
	mov byte [si-2],40
	mov byte [si-1],15
repeat_gs1:
	call _move_snake
	call _rand_and_draw_apples
	call _keyboard_game_support
	cmp ah, -1
	je done_gs1
	jmp repeat_gs1			; infinite loop
done_gs1:
	add sp,2002
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
	mov ah, 0
	int 01ah
	mov cx, [rand_num]
	rcr dx,cl
	mov [rand_num],dx
	popa
	ret
;;;;;;;;;;;;;;;_random;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;_modulo;;;;;;;;;;;;;;;;;;;;;;;;;;
_modulo:

repeat_mod1:
	cmp ax,bx
	jb done_m1
	sub ax,bx
	jmp repeat_mod1
done_m1:

	ret	
;;;;;;;;;;;;;;_modulo;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;;;;;;;;;;;;;;_draw_empy_lines;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;_rand apples;;;;;;;;;;;;;;;;;;;
_rand_and_draw_apples:
	pusha
	mov cx,0
	mov si,apples_x
	mov di,apples_y
	mov ah,0
	mov bh,0
repeat_rada:
	cmp byte [si],0
	jne next_rada
	call _random
	mov dh,[rand_num]
	mov al,dh
	mov bl,77
	call _modulo
	add al,1
	mov byte [si],al
	call _random
	mov dh,[rand_num]
	mov al,dh
	mov bl,21
	call _modulo
	add al,1
	mov byte [di],al
next_rada:
	inc cx
	inc si
	inc di
	cmp cx,2
	jne repeat_rada

	call _draw_apples
	popa 
	ret
;;;;;;;;;;;;;;;;_rand apples;;;;;;;;;;;;;;;;;;;
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
	mov si,[snake_memory]
	movzx bx,byte[snake_len]
	sub bl,1
	shl bl,1
	mov dh,[si+bx]
	mov dl,[si+bx+1]
	mov [si-2],dh
	mov [si-1],dl
	mov dh,[si]
	mov dl,[si+1]
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
	je esc
	jmp nothing_to_do
left:
	cmp dh,1
	je nothing_to_do
	sub dh,1
    jmp done_gt1
right:
	cmp dh,78
	je nothing_to_do
	add dh,1
	jmp done_gt1
up:
	cmp dl,1
	je nothing_to_do
	sub dl,1
	jmp done_gt1
down:
	cmp dl,22
	je nothing_to_do
	add dl,1
	jmp done_gt1
esc:
	mov ah,-1
	jmp nothing_to_do
restart:
;;;todo
	jmp nothing_to_do
done_gt1:

	movzx bx,[snake_len]
	dec bx
	shl bx,2
repeat_gt2:
	cmp bx,0
	je done_gt2

	mov ah,[si+bx-2]
	mov al,[si+bx-1]
	mov [si+bx],ah
	mov [si+bx+1],al
	sub bx,2
	jmp repeat_gt2

done_gt2:
 	mov [si],dh
 	mov [si+1],dl
 	jmp return_gt2
nothing_to_do:
	mov byte [si-2],-1
	mov byte [si-1],-1
return_gt2:
	ret
;;;;;;;;;;;;;;;;;;;;;;;;_keyboard_game_support;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;_move_snake;;;;;;;;;;;;;;;;;;;;;;;;;
_move_snake:
	pusha
	movzx cx,byte [snake_len]
	mov si,[snake_memory]
repeat_ms1:
	cmp cx,0
	je done_ms1
	push cx
	mov cx,1
	mov bp, snake
	mov ax, ds
	mov es, ax        
	mov ah, 13h        ;SERVICE TO DISPLAY STRING WITH COLOR.
	mov bh, 0          ;PAGE (ALWAYS ZERO).
	mov bl, 00010000b
	mov dl, [si]  
	mov dh, [si+1]  
	int 10h           ;BIOS SCREEN SERVICES.  
	add si,2
	pop cx
	dec cx
	jmp repeat_ms1

done_ms1:
	mov si,[snake_memory]
	mov cx,1
	mov bp, white_sign
	mov ax, ds
	mov es, ax        
	mov ah, 13h        ;SERVICE TO DISPLAY STRING WITH COLOR.
	mov bh, 0          ;PAGE (ALWAYS ZERO).
	mov bl, 0
	mov dl, [si-2]  
	mov dh, [si-1]  
	cmp dl, -1
	je done_ms2
	int 10h           ;BIOS SCREEN SERVICES.  
done_ms2:
	popa
	ret
;;;;;;;;;;;;;;;;;;;;;;;_move_snake;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;_draw_apples;;;;;;;;;;;;;;;;;;;;;;;;;
_draw_apples:
	pusha
	mov si,apples_x
	mov di, apples_y
	mov cx,2
	
repeat_da1:
	cmp cx,0
	je done_da1
	dec cx
	push cx
	
	mov cx,1
	mov bp, apple
	mov ax, ds
	mov es, ax        
	mov ah, 13h        ;SERVICE TO DISPLAY STRING WITH COLOR.
	mov bh, 0          ;PAGE (ALWAYS ZERO).
	mov bl, 00110000b
	mov dl, [si] 
	mov dh, [di]
	int 10h           ;BIOS SCREEN SERVICES.  
	
	pop cx
	inc si
	inc di
	jmp repeat_da1
done_da1:
	popa
	ret
;;;;;;;;;;;;;;;;;;;;;;;_draw_apples;;;;;;;;;;;;;;;;;;;;;;;;;
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
	snake_memory dw 0
	time db 0,0
	snake db 'x'
	snake_len db 3
	snake_legend db 'Arrow keys, esc to exit.',0
	rand_num db 1,1,0
	white_sign db ' '
	apple db 'o'
	apples_x db -1,-1,0
	apples_y db -1,-1,0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;boot_signature;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	times 4096 - ($ - $$) db 0
