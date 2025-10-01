ASM=nasm
SRC_DIR=src
BUILD_DIR=build

$(BUILD_DIR)/bl.img: $(BUILD_DIR)/bl.bin
	cp $(BUILD_DIR)/bl.bin $(BUILD_DIR)/bl.img
	truncate -s 1440k $(BUILD_DIR)/bl.img

$(BUILD_DIR)/bl.bin: $(SRC_DIR)/bl.asm
	$(ASM) $(SRC_DIR)/bl.asm -f bin -o $(BUILD_DIR)/bl.bin
