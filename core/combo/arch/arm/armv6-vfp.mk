# Configuration for Linux on ARM.
# Generating binaries for the ARMv6-VFP architecture and higher
#
ARCH_ARM_HAVE_THUMB_SUPPORT     := true
ARCH_ARM_HAVE_FAST_INTERWORKING := true
ARCH_ARM_HAVE_64BIT_DATA        := true
ARCH_ARM_HAVE_HALFWORD_MULTIPLY := true
ARCH_ARM_HAVE_CLZ               := true
ARCH_ARM_HAVE_FFS               := true
ARCH_ARM_HAVE_VFP               := true

ifeq ($(strip $(TARGET_CPU_VARIANT)),)
TARGET_CPU_VARIANT              := generic
endif
ifeq ($(strip $(TARGET_ARCH_VARIANT_FPU)),)
TARGET_ARCH_VARIANT_FPU         := vfp
endif
ifeq ($(strip $(TARGET_ARCH_VARIANT_CPU)),)
TARGET_ARCH_VARIANT_CPU         := arm1136jf-s
endif

# Note: Hard coding the 'tune' value here is probably not ideal,
# and a better solution should be found in the future.
#
arch_variant_cflags := \
    -mfloat-abi=softfp \
    -mfpu=$(TARGET_ARCH_VARIANT_FPU) \
    -D__ARM_ARCH_5__ \
    -D__ARM_ARCH_5T__ \
    -D__ARM_ARCH_5E__ \
    -D__ARM_ARCH_5TE__ \
    -D__ARM_ARCH_6__ \
    -D__ARM_ARCH_6J__ \
    -D__ARM_ARCH_6K__

# Note: If the CPU is arm1136jf-s, the compiler assumes that the CPU is revision r1p0
# This is is problematic, as the msm7x27 series is revision r1p1 or later, which
# prevents us from using the full register set. Force -march=armv6k in this case.
#
ifeq ($(strip $(TARGET_ARCH_VARIANT_CPU)),arm1136jf-s)
    arch_variant_cflags += \
        -march=armv6k
else
    arch_variant_cflags += \
        -mcpu=$(TARGET_ARCH_VARIANT_CPU)
endif