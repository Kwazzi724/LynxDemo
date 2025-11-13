# Lynx Development Makefile
CC65_HOME = ../cc65
CC = $(CC65_HOME)/bin/cc65.exe
CA = $(CC65_HOME)/bin/ca65.exe
LD = $(CC65_HOME)/bin/ld65.exe
SPRPCK = ../sprpck/sprpck.exe

# Target
TARGET = mygame.lnx

# Directories
SRC_DIR = src
ASSETS_DIR = assets
BUILD_DIR = build

# Source files
C_SOURCES = $(SRC_DIR)/main.c
ASM_SOURCES = 
BMP_SOURCES = $(ASSETS_DIR)/sprite.bmp

# Object files
C_OBJECTS = $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(C_SOURCES))
BMP_OBJECTS = $(patsubst $(ASSETS_DIR)/%.bmp,$(BUILD_DIR)/%.o,$(BMP_SOURCES))

# Flags
CFLAGS = -t lynx -O -Or -Cl
AFLAGS = -t lynx
LDFLAGS = -t lynx -C lynx.cfg

# All target
all: $(BUILD_DIR) $(TARGET)

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Link
$(TARGET): $(C_OBJECTS) $(BMP_OBJECTS)
	$(LD) $(LDFLAGS) -o $@ $^ lynx.lib

# Compile C files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/$*.s $<
	$(CA) $(AFLAGS) -o $@ $(BUILD_DIR)/$*.s

# Convert BMP to sprite data
$(BUILD_DIR)/%.o: $(ASSETS_DIR)/%.bmp
	$(SPRPCK) -t6 -p2 $< -o $(BUILD_DIR)/$*
	@echo .global _$(*F) > $(BUILD_DIR)/$*.s
	@echo .segment \"RODATA\" >> $(BUILD_DIR)/$*.s
	@echo _$(*F): >> $(BUILD_DIR)/$*.s
	@echo .incbin \"$*.spr\" >> $(BUILD_DIR)/$*.s
	$(CA) $(AFLAGS) -o $@ $(BUILD_DIR)/$*.s

# Clean
clean:
	rm -rf $(BUILD_DIR)
	rm -f $(TARGET)

# Run in emulator
run: $(TARGET)
	../Mednafen/mednafen.exe $(TARGET)

.PHONY: all clean run