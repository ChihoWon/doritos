all: kernel.bin

kernel.bin: Entry.s
	nasm -o kernel.bin $<

clean:
	rm -f kernel.bin
