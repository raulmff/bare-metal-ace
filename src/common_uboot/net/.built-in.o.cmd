cmd_net/built-in.o :=  arm-none-eabi-ld.bfd     -r -o net/built-in.o net/checksum.o net/arp.o net/bootp.o net/eth_legacy.o net/eth_common.o net/net.o net/ping.o net/tftp.o 
