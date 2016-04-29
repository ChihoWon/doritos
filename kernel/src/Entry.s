[org 0]
[bits 16]

start:
  mov ax, 0x1000
  mov ds, ax
  mov es, ax

  cli   ; Disable interrupt
  lgdt [gdtr]

  ; Entering protected mode
  mov eax, 0x4000003b
  mov cr0, eax

  jmp dword 0x8: (0x10000 + protected_mode - $$)

; Protected mode
[bits 32]
protected_mode:
  mov ax, 0x10  ; Data Segment Selector (Kernel)
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ss, ax
  mov esp, 0xFFFE
  mov ebp, 0xFFFE

  push (0x10000 + switched_message - $$)
  push 2
  push 0
  call printxy
  add esp, 12

  jmp dword 0x8: 0x10200

  ; jmp $   ; halt

; printxy 32 bit ver.
printxy:
	push ebp
	mov  ebp, esp
	push esi
	push edi
	push edx
	push ecx
	push ebx
	push eax

; Coordinate precalculation
print_precal:
	mov eax, dword[ebp + 8]
	mov esi, 2
	mul esi
	mov edi, eax

	mov eax, dword[ebp + 12]
	mov esi, 160
	mul esi
	add edi, eax

	mov esi, dword[ebp + 16]

print_loop:
	mov cl, byte[esi]
	mov byte[edi + 0xB8000], cl
	add esi, 1
	add edi, 2
	cmp cl, 0
	jnz print_loop

; Stack frame clear
print_clear:
	pop eax
	pop ebx
	pop ecx
	pop edx
	pop edi
	pop esi
	pop ebp
	ret


; Global Descriptor Table
align 8, db 0   ; size padding
dw 0

gdtr:
  dw gdt_end - gdt - 1
  dd (0x10000 + gdt - $$)

gdt:
gdt_null:
  dd 0
  dd 0

gdt_code:
  dd 0x0000FFFF
  dd 0x00CF9A00

gdt_data:
  dd 0x0000FFFF
  dd 0x00CF9200

gdt_end:

switched_message: db '[!] Switched to protected mode', 0
times 512 - ($ - $$) db 0
