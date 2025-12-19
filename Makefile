ASM=nasm
SRC_DIR=src
BUILD_DIR=build

all:
	rm -rf $(BUILD_DIR)/*
	$(ASM) $(SRC_DIR)/bootloader/stage1.asm -f bin -o $(BUILD_DIR)/stage1.bin
	$(ASM) $(SRC_DIR)/bootloader/stage2.asm -f bin -o $(BUILD_DIR)/stage2.bin
	dd if=/dev/zero of=$(BUILD_DIR)/floppy.img bs=512 count=2880
	mkfs.fat -F12 -S512 -s1 $(BUILD_DIR)/floppy.img
	mkdir $(BUILD_DIR)/mnt
	mkdir $(BUILD_DIR)/mnt/floppy
	dd if=$(BUILD_DIR)/stage1.bin of=$(BUILD_DIR)/floppy.img bs=512 count=1 conv=notrunc
	mount -o loop $(BUILD_DIR)/floppy.img $(BUILD_DIR)/mnt/floppy
	cp $(BUILD_DIR)/stage2.bin $(BUILD_DIR)/mnt/floppy
	umount $(BUILD_DIR)/mnt/floppy
	qemu-system-i386 -fda $(BUILD_DIR)/floppy.img


