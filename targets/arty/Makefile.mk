# arty targets

ifneq ($(PLATFORM),arty)
	$(error "Platform should be arty when using this file!?")
endif

# Settings
DEFAULT_TARGET = net
TARGET ?= $(DEFAULT_TARGET)

PROG_PORT ?= /dev/ttyUSB0
COMM_PORT ?= /dev/ttyUSB1
BAUD ?= 115200

# Image
image-flash-$(PLATFORM): image-flash-py
	@true

.PHONY: image-flash-$(PLATFORM)

# Gateware
gateware-load-$(PLATFORM):
	openocd -f board/digilent_$(PLATFORM).cfg -c "init; pld load 0 $(TARGET_BUILD_DIR)/gateware/top.bit; exit"

gateware-flash-$(PLATFORM): gateware-flash-py
	@true

.PHONY: gateware-load-$(PLATFORM) gateware-flash-$(PLATFORM)

# Firmware
firmware-load-$(PLATFORM):
	flterm --port=$(COMM_PORT) --kernel=$(TARGET_BUILD_DIR)/software/firmware/firmware.bin --speed=$(BAUD)

firmware-flash-$(PLATFORM): firmwage-flash-py
	@true

firmware-connect-$(PLATFORM):
	flterm --port=$(COMM_PORT) --speed=$(BAUD)

.PHONY: firmware-load-$(PLATFORM) firmware-flash-$(PLATFORM) firmware-connect-$(PLATFORM)

# Bios
bios-flash-$(PLATFORM):
	@echo "Unsupported."
	@false

.PHONY: bios-flash-$(PLATFORM)

# Extra commands
help-$(PLATFORM):
	@true

reset-$(PLATFORM):
	@echo "Unsupported."
	@false

.PHONY: help-$(PLATFORM) reset-$(PLATFORM)
