NEOTERIC_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)

NEOTERIC_TARGET := Neoteric-OS_$(TARGET_DEVICE)-$(NEOTERIC_VERSION)-$(NEOTERIC_BUILD_DATE)
NEOTERIC_OTA_PACKAGE := $(PRODUCT_OUT)/$(NEOTERIC_TARGET).zip
NEOTERIC_FASTBOOT_PACKAGE := $(PRODUCT_OUT)/$(NEOTERIC_TARGET)-fastboot.zip

$(NEOTERIC_OTA_PACKAGE): $(BUILT_TARGET_FILES_PACKAGE) $(OTA_FROM_TARGET_FILES)
	$(call build-ota-package-target,$@, --output_metadata_path $(INTERNAL_OTA_METADATA))
ifneq ($(IS_CUSTOM),false)
	$(hide) ./vendor/neoteric/tools/generate_json_build_info.sh $(NEOTERIC_OTA_PACKAGE)
endif

$(NEOTERIC_FASTBOOT_PACKAGE): $(BUILT_TARGET_FILES_PACKAGE) $(IMG_FROM_TARGET_FILES)
	$(IMG_FROM_TARGET_FILES) \
		--additional IMAGES/VerifiedBootParams.textproto:VerifiedBootParams.textproto \
	    	$(BUILT_TARGET_FILES_PACKAGE) $@

.PHONY: bacon fastboot

bacon: $(NEOTERIC_OTA_PACKAGE)
	@echo "Package Complete: $(NEOTERIC_OTA_PACKAGE)"

fastboot: $(NEOTERIC_FASTBOOT_PACKAGE)
	@echo "Package Complete: $(NEOTERIC_FASTBOOT_PACKAGE)"

