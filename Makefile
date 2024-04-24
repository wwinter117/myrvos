# Cross-compilation tools
CROSS_COMPILE := riscv64-unknown-elf-
CC := $(CROSS_COMPILE)gcc
OBJCOPY := $(CROSS_COMPILE)objcopy
OBJDUMP := $(CROSS_COMPILE)objdump
GDB := gdb-multiarch

# QEMU settings
QEMU := qemu-system-riscv32
QFLAGS := -nographic -smp 1 -machine virt -bios none

# Compiler and linker flags
CFLAGS := -nostdlib -fno-builtin -march=rv32g -mabi=ilp32 -g -Wall

# Source and build directories
SRC_DIR := src
BUILD_DIR := build
ASM_SRC := $(wildcard $(SRC_DIR)/*.S)
C_SRC := $(wildcard $(SRC_DIR)/*.c)
ASM_OBJ := $(patsubst $(SRC_DIR)/%.S,$(BUILD_DIR)/%.o,$(ASM_SRC))
C_OBJ := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(C_SRC))
OBJS := $(ASM_OBJ) $(C_OBJ)

# Target executable and binary
TARGET_ELF := $(BUILD_DIR)/os.elf
TARGET_BIN := $(BUILD_DIR)/os.bin

# Default target
.DEFAULT_GOAL := all

# Main targets
all: $(TARGET_ELF)

$(TARGET_ELF): $(BUILD_DIR) $(OBJS)
	$(CC) $(CFLAGS) -T os.ld -o $@ $(OBJS)
	$(OBJCOPY) -O binary $@ $(TARGET_BIN)

# Build directory
$(BUILD_DIR):
	mkdir -p $@

# Object file rules
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.S
	$(CC) $(CFLAGS) -c $< -o $@

# Run target
run: $(TARGET_ELF)
	@$(QEMU) -M ? | grep virt >/dev/null || exit
	@echo "Press Ctrl-A and then X to exit QEMU"
	@echo "------------------------------------"
	@$(QEMU) $(QFLAGS) -kernel $(TARGET_ELF)

.PHONY : debug
debug: all
	@echo "Press Ctrl-C and then input 'quit' to exit GDB and QEMU"
	@echo "-------------------------------------------------------"
	@${QEMU} ${QFLAGS} -kernel $(TARGET_ELF) -s -S &
	@${GDB} $(TARGET_ELF) -q -x ./gdbinit

# Disassemble target
.PHONY: code
code: $(TARGET_ELF)
	@$(OBJDUMP) -S $(TARGET_ELF)

# Clean target
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

.PHONY: hex
hex: $(TARGET_ELF)
	@hexdump -C $(TARGET_ELF)

