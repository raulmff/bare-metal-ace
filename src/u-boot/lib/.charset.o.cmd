cmd_lib/charset.o := arm-none-eabi-gcc -Wp,-MD,lib/.charset.o.d  -nostdinc -isystem /usr/lib/gcc/arm-none-eabi/6.3.1/include -Iinclude   -I./arch/arm/include -include ./include/linux/kconfig.h -D__KERNEL__ -D__UBOOT__ -Wall -Wstrict-prototypes -Wno-format-security -fno-builtin -ffreestanding -std=gnu11 -fshort-wchar -fno-PIE -Os -fno-stack-protector -fno-delete-null-pointer-checks -g -fstack-usage -Wno-format-nonliteral -Werror=date-time -D__ARM__ -marm -mno-thumb-interwork -mabi=aapcs-linux -mword-relocations -fno-pic -mno-unaligned-access -ffunction-sections -fdata-sections -fno-common -ffixed-r9 -msoft-float -pipe -march=armv7-a -D__LINUX_ARM_ARCH__=7    -D"KBUILD_STR(s)=\#s" -D"KBUILD_BASENAME=KBUILD_STR(charset)"  -D"KBUILD_MODNAME=KBUILD_STR(charset)" -c -o lib/charset.o lib/charset.c

source_lib/charset.o := lib/charset.c

deps_lib/charset.o := \
  include/charset.h \
  include/linux/types.h \
    $(wildcard include/config/uid16.h) \
    $(wildcard include/config/use/stdint.h) \
  include/linux/posix_types.h \
  include/linux/stddef.h \
  arch/arm/include/asm/posix_types.h \
  arch/arm/include/asm/types.h \
    $(wildcard include/config/arm64.h) \
    $(wildcard include/config/phys/64bit.h) \
    $(wildcard include/config/dma/addr/t/64bit.h) \
  /usr/lib/gcc/arm-none-eabi/6.3.1/include/stdbool.h \
  include/malloc.h \
    $(wildcard include/config/sys/malloc/simple.h) \

lib/charset.o: $(deps_lib/charset.o)

$(deps_lib/charset.o):
