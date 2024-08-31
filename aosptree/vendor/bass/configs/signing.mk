# Signature System For Bass

ifeq ($(BLISS_PRODUCTION_BUILD),true)
# Flavor and signing

# If vendor/bliss/config/signing/releasekey exists, then we can apply the properties
ifneq ($(wildcard vendor/bliss/config/signing/releasekey),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bliss.releasetype=RELEASE \

SIGNING_KEYS := vendor/bliss/config/signing

PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/bliss/config/signing/releasekey
PRODUCT_OTA_PUBLIC_KEYS := vendor/bliss/config/signing/platform
PRODUCT_EXTRA_RECOVERY_KEYS := vendor/bliss/config/signing/platform
endif

ifneq ($(wildcard vendor/bass/configs/signing/releasekey),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bliss.releasetype=RELEASE \

SIGNING_KEYS := vendor/bass/configs/signing

PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/bass/configs/signing/releasekey
PRODUCT_OTA_PUBLIC_KEYS := vendor/bass/configs/signing/platform
PRODUCT_EXTRA_RECOVERY_KEYS := vendor/bass/configs/signing/platform
endif

endif

ifneq ($(SIGNING_KEYS),)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := $(SIGNING_KEYS)/releasekey
endif
