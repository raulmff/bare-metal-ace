cmd_common/built-in.o :=  arm-none-eabi-ld.bfd     -r -o common/built-in.o common/init/built-in.o common/main.o common/exports.o common/hash.o common/cli_hush.o common/autoboot.o common/board_f.o common/board_r.o common/bootm.o common/bootm_os.o common/fdt_support.o common/miiphyutil.o common/flash.o common/splash.o common/menu.o common/cli_readline.o common/cli_simple.o common/console.o common/dlmalloc.o common/image.o common/image-fdt.o common/memsize.o common/stdio.o common/cli.o common/command.o common/s_record.o common/xyzModem.o 