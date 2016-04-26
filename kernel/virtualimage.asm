%define TOTAL_SECTOR_COUNT 1024

[org 0]
[bits 16]

jmp 0x1000:start
sector_count: dw 0

start:
  mov ax, cs
  mov ds, ax
  mov ax, 0xB800
  mov es, ax

  %assign i 0
  %rep TOTAL_SECTOR_COUNT
    %assign i (i + 1)
    mov ax, 2
    mul word[sector_count]
    mov si, ax

    mov byte[es:si + (160 * 2)], '0' + (i % 10)
    add word[sector_count], 1

    %if i == TOTAL_SECTOR_COUNT
      jmp $
    %else
      jmp (0x1000 + i * 0x20):0x0000
    %endif

    times (512 - ($ - $$) % 512) db 0
  %endrep
