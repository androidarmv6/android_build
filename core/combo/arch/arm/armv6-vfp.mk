# Configuration for Linux on ARM.
# Generating binaries for the ARMv6-VFP architecture and higher
#
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

# Note: If the CPU is arm1136jf-s, the compiler will treat the CPU as revision r1p0.
# This is is problematic, as the msm7x27 series is revision r1p1 or later, which
# prevents us from using new registers added in r1p1+. Force -march=armv6k in this case.
#
ifeq ($(strip $(TARGET_ARCH_VARIANT_CPU)),arm1136jf-s)
    arch_variant_cflags := \
        -march=armv6k
else
    arch_variant_cflags := \
        -mcpu=$(TARGET_ARCH_VARIANT_CPU)
endif

# Note: Hard coding the 'tune' value here is probably not ideal,
# and a better solution should be found in the future.
#
arch_variant_cflags += \
    -mfloat-abi=softfp \
    -mfpu=$(TARGET_ARCH_VARIANT_FPU) \
    -D__ARM_ARCH_5__ \
    -D__ARM_ARCH_5T__ \
    -D__ARM_ARCH_5E__ \
    -D__ARM_ARCH_5TE__ \
    -D__ARM_ARCH_6__ \
    -D__ARM_ARCH_6J__ \
    -D__ARM_ARCH_6K__
