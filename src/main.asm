org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A


start:
	jmp main


clear_screen:
	mov ah, 0x00 ; calls bios interrupt
	int 0x10
	ret

;
; prints a string to the screen
; params:
;	- ds:si points to string
;
puts:
	; save registers that will be modified
	push si 
	push ax

.loop:
	lodsb ; loads next character in al
	or al, al ; verify if next character is null
	jz .done

	mov ah, 0x0e ; calls bios interrupt
	mov bh, 0
	int 0x10

	jmp .loop

.done:
	pop ax
	pop si
	ret


main:

	; setup data segments
	mov ax, 0
	mov ds, ax
	mov es, ax

	; setup stack
	mov ss, ax
	mov sp, 0x7C00 ; stack gros downwards

	; clear screen
	call clear_screen

	; print message
	mov si, welcome_msg
	call puts

	hlt


.halt:
	jmp .halt


welcome_msg: db "Welcome to GooberOS", ENDL, 0

times 510-($-$$) db 0
dw 0AA55h
