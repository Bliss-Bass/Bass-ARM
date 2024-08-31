# Watermark System For Bass

ifneq ($(BLISS_PRODUCTION_BUILD),true)
# Watermark for Bliss Bass test builds
# Fields are:
# text%fontsize%deltax%deltay%shadowcolor%color%shadowradius%shadowdx%shadowdy
# For more info, see:
# frameworks/base/services/core/java/com/android/server/wm/Watermark.java
# and to configure the watermark, see:
# vendor/bliss/config/watermark/create_watermark/README.md (access required)
PRODUCT_COPY_FILES += \
    vendor/bass/configs/watermark/watermark.conf:system/etc/setup.conf
endif