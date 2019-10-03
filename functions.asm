;board_string_1 dw 07E00h
;board_string_size db 81
section .text
;;;;;;;;;;;;;;;;;;;;;;;;functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_clear_screen:
	mov cx,25
;;;;;;;;;;;;;
next_line_clear:
	mov si,next_line_str
	call _print_str
	dec cx
	cmp cx,0
	jne next_line_clear
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;EXAMPLE HOW TO USE;;;;
;;;	mov si, str;;;;
;;; call _print_str;;;;;

_print_str:
	mov ah, 0Eh
repeat_ps1:
	lodsb
	cmp al, 0
	je done_ps1
	int 10h
	jmp repeat_ps1
	done_ps1:
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_load_board_strings:
	;mov ax, word [board_string_1]
	;mov cx, word [board_string_size]
	mov bh, 'x'

repeat_lbs1:
	;mov byte [ax],bh
	dec cx
	inc ax
	cmp cx,0
	jne repeat_lbs1

;;;;;;;;;;;;;;;;;;;;
	;mov [ax],10
	;mov [ax+1],0
	ret	