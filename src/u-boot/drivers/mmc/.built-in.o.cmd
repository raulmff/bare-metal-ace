cmd_drivers/mmc/built-in.o :=  arm-none-eabi-ld.bfd     -r -o drivers/mmc/built-in.o drivers/mmc/mmc.o drivers/mmc/mmc_write.o drivers/mmc/mmc_legacy.o drivers/mmc/arm_pl180_mmci.o 
