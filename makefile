all: Bootloader Kernel Disk.img

Bootloader:
	@echo [!] Building boot loader ...

	make -C bootloader

	@echo [!] Build Complete

Kernel:
	@echo [!] Building Kernel image ...

	make -C kernel

	@echo [!] Build Complete

Disk.img: bootloader kernel
	@echo [!] Building disk image ...

	cat bootloader/bootloader.bin kernel/kernel.bin > disk.img

	@echo [!] Build sequence complete

clean:
	make -C bootloader clean
	make -C kernel clean
	rm -f disk.img
