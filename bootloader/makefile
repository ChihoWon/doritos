all: Bootloader.bin

Bootloader.bin: bootloader.asm
	nasm -o bootloader.bin bootloader.asm

clean:
	rm -f bootloader.bin
