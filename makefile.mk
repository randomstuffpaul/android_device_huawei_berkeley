INSTALLED_KERNELIMAGE_TARGET := $(PRODUCT_OUT)/kernel.img
INSTALLED_RAMDISKIMAGE_TARGET := $(PRODUCT_OUT)/ramdisk-image.img

INTERNAL_KERNEL_CMDLINE := $(strip $(BOARD_KERNEL_CMDLINE) buildvariant=$(TARGET_BUILD_VARIANT) $(VERITY_KEYID))

INTERNAL_KERNELIMAGE_ARGS := \
	--kernel $(INSTALLED_KERNEL_TARGET) \
	--ramdisk /dev/null \
	--base $(BOARD_KERNEL_BASE) \
	--pagesize $(BOARD_KERNEL_PAGESIZE) \
	--kernel_offset $(BOARD_KERNEL_OFFSET) \
	--second_offset $(BOARD_KERNEL_SECOND_OFFSET) \
	--tags_offset $(BOARD_KERNEL_TAGS_OFFSET) \
	--cmdline "$(INTERNAL_KERNEL_CMDLINE)"

INTERNAL_RAMDISKIMAGE_ARGS := \
	--kernel /dev/null \
	--ramdisk $(BUILT_RAMDISK_TARGET) \
	--cmdline "buildvariant=$(TARGET_BUILD_VARIANT)" \
	--base $(BOARD_KERNEL_BASE) \
	--pagesize $(BOARD_KERNEL_PAGESIZE) \

$(INSTALLED_KERNELIMAGE_TARGET): $(MKBOOTIMG) $(INSTALLED_KERNEL_TARGET)
	$(call pretty,"Target kernel image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_KERNELIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_KERNELIMAGE_PARTITION_SIZE))

$(INSTALLED_RAMDISKIMAGE_TARGET): $(MKBOOTIMG) $(BUILT_RAMDISK_TARGET)
	$(call pretty,"Target ram disk image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_RAMDISKIMAGE_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RAMDISKIMAGE_PARTITION_SIZE))

.PHONY: kernelimage
bootimage: $(INSTALLED_KERNELIMAGE_TARGET)

.PHONY: ramdiskimage
bootimage: $(INSTALLED_RAMDISKIMAGE_TARGET)
