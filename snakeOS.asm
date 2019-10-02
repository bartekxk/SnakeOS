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

	mov si, rows
	call _print_str

	jmp $			; Jump here - infinite loop!


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;variables;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	next_line_str db 10,0
;;;
	rows db 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',10,
			 db	'                                                                                ',10,
			 db	'                                                                                ',10,
			 db	'                                                                                ',10,
			 db	'                                                                                ',10,
			 db	'                                                                                ',10,
			 db	'                                                                                ',10,
			 db	'                                                                                ',10,
			 db	'                                                                                ',10,
			 db	'                                                                                ',10,
			 db	'                                                                                ',10,
			 db	'                                                                                ',10,
			 db	'                                                                                ',10,
			 db	'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',10,0

;;;;;;;;;;;;;;;;;;;;;;;;functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_clear_screen:
	mov cx,25
	next_line_clear:
	mov si,next_line_str
	call _print_str
	dec cx
	cmp cx,0
	jne next_line_clear
	ret

;;;;;;;
_print_str:
	mov ah, 0Eh
repeat:
	lodsb
	cmp al, 0
	je done
	int 10h
	jmp repeat
	done:
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;boot_signature;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	times 2040-($-$$) db 0
	dw 0xAA55
