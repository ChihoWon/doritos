%include "boot.mac"

[org 0]
[bits 16]

jmp 0x07C0:start
total_sector: dw 1024

start:
	mov ax, CODE_SEG
	mov ds, ax
	mov ax, VMEM_SEG
	mov es, ax

main:
	xor si, si
	call init_screen

	push boot_message
	push 0
	push 0
	call printxy
	add sp, 6

	push disk_loading
	push 1
	push 0
	call printxy
	add sp, 6

; Disk reset
; ah = 0 (reset), dl = 0 (Floppy)
reset_disk:
	mov ax, 0
	mov dl, 0
	int 0x13
	jc disk_error_handler

; Destination: 0x1000:0000 (es:bx)
read_init:
	mov si, 0x1000
	mov es, si
	mov bx, 0
	mov di, word[total_sector]

read_data:
	cmp di, 0
	je read_complete
	dec di

	mov ah, 2
	mov al, 1
	mov ch, byte[track_number]
	mov cl, byte[sector_number]
	mov dh, byte[head_number]
	mov dl, 0
	int 0x13
	jc disk_error_handler

	add si, 0x0020
	mov es, si

	add byte[sector_number], 1
	cmp byte[sector_number], 19
	jl read_data

	xor byte[head_number], 1
	mov byte[sector_number], 1

	cmp byte[head_number], 0
	jne read_data
	add byte[track_number], 1
	jmp read_data

read_complete:
	push disk_suc_msg
	push 1
	push 45
	call printxy
	add sp, 6

	jmp 0x1000:0x0000


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1. init_screen
; Clear screen
init_screen:
	mov byte[es:si],	0
	mov byte[es:si+1],	SET_FONT(BLACK, GREEN)
	add si, 2
	cmp si, SCREEN_SIZE
	jl init_screen
	ret

; 2. printxy
; Print message
printxy:
	push bp
	mov bp, sp
	push si
	push di
	push dx
	push cx
	push bx
	push ax

; Coordinate precalculation
print_precal:
	mov ax, word[bp + 4]
	mov si, 2
	mul si
	mov di, ax

	mov ax, word[bp + 6]
	mov si, 160
	mul si
	add di, ax

	mov si, word[bp + 8]

	mov ax, VMEM_SEG
	mov es, ax

print_loop:
	mov cl, byte[si]
	mov byte[es:di], cl
	add si, 1
	add di, 2
	cmp cl, 0
	jnz print_loop

; Stack frame clear
print_clear:
	pop ax
	pop bx
	pop cx
	pop dx
	pop di
	pop si
	pop bp
	ret

; 3. disk_error_handler
; Handling disk loading error
disk_error_handler:
	push disk_err_msg
	push 1
	push 45
	call printxy
	jmp $



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Message strings
boot_message: db '[!] Mentos OS Bootloader', 0
disk_loading: db '[!] Kernel image loading ...', 0
disk_err_msg: db '[fail]', 0
disk_suc_msg: db '[pass]', 0

; Variables
sector_number:	db 2
head_number:		db 0
track_number:		db 0

times 510 - ($ - $$) db 0
dw 0xAA55
