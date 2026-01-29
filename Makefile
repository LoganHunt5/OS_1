ASM=nasm
SRC_DIR=src
BUILD_DIR=build
CC_PATH=/home/logan/opt/cross/bin
CC=$(CC_PATH)/i686-elf-gcc

run:
	rm -rf $(BUILD_DIR)/*
	$(ASM) $(SRC_DIR)/bootloader/stage1.asm -f bin -o $(BUILD_DIR)/stage1.bin
	$(ASM) $(SRC_DIR)/bootloader/stage2.asm -f bin -o $(BUILD_DIR)/stage2.bin
	# $(ASM) $(SRC_DIR)/kernel/kernel.asm -f bin -o $(BUILD_DIR)/kernel.bin
	$(CC) -c $(SRC_DIR)/kernel/kernel.c -o $(BUILD_DIR)/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
	# $(CC) -T $(SRC_DIR)/kernel/linker.ld -o $(BUILD_DIR)/kernel -ffreestanding -O2 -nostdlib $(BUILD_DIR)/kernel.o -lgcc
	$(CC) -o $(BUILD_DIR)/kernel -ffreestanding -O2 -nostdlib $(BUILD_DIR)/kernel.o -lgcc
	dd if=/dev/zero of=$(BUILD_DIR)/floppy.img bs=512 count=2880
	mkfs.fat -F12 -S512 -s1 $(BUILD_DIR)/floppy.img
	mkdir $(BUILD_DIR)/mnt
	mkdir $(BUILD_DIR)/mnt/floppy
	dd if=$(BUILD_DIR)/stage1.bin of=$(BUILD_DIR)/floppy.img bs=512 count=1 conv=notrunc
	mount -o loop $(BUILD_DIR)/floppy.img $(BUILD_DIR)/mnt/floppy
	cp $(BUILD_DIR)/stage2.bin $(BUILD_DIR)/mnt/floppy
	# cp $(BUILD_DIR)/kernel.bin $(BUILD_DIR)/mnt/floppy
	cp $(BUILD_DIR)/kernel $(BUILD_DIR)/mnt/floppy
	umount $(BUILD_DIR)/mnt/floppy
	qemu-system-i386 -fda $(BUILD_DIR)/floppy.img

test:
	rm -rf $(BUILD_DIR)/*
	$(ASM) $(SRC_DIR)/bootloader/stage1.asm -f bin -o $(BUILD_DIR)/stage1.bin
	$(ASM) $(SRC_DIR)/bootloader/stage2.asm -f bin -o $(BUILD_DIR)/stage2.bin
	$(ASM) $(SRC_DIR)/kernel/kernel.asm -f bin -o $(BUILD_DIR)/kernel.bin
	dd if=/dev/zero of=$(BUILD_DIR)/floppy.img bs=512 count=2880
	mkfs.fat -F12 -S512 -s1 $(BUILD_DIR)/floppy.img
	mkdir $(BUILD_DIR)/mnt
	mkdir $(BUILD_DIR)/mnt/floppy
	dd if=$(BUILD_DIR)/stage1.bin of=$(BUILD_DIR)/floppy.img bs=512 count=1 conv=notrunc
	mount -o loop $(BUILD_DIR)/floppy.img $(BUILD_DIR)/mnt/floppy
	cp $(BUILD_DIR)/stage2.bin $(BUILD_DIR)/mnt/floppy
	cp $(BUILD_DIR)/kernel.bin $(BUILD_DIR)/mnt/floppy
	umount $(BUILD_DIR)/mnt/floppy
	qemu-system-i386 -s -S -fda $(BUILD_DIR)/floppy.img

debug:
	@echo "Current PATH is: $(PATH)"
	@which i686-elf-gcc || echo "Compiler not found in PATH"
