----- Precisa ter instalado -----
qemu-system-arm (sudo apt-get install qemu-system-arm)
gcc-arm-none-eabi (sudo apt-get install gcc-arm-none-eabi)
build-essential
cmake (sudo apt-get install build-essential cmake)
bison
flex (sudo apt-get install bison flex)

----- Passos para rodar o código -----

1. Suba na pasta "code" e execute cmake
$ cmake -S . -Bbuild

2. Suba na pasta "build", execute abaixo para nao dar problema com o "nbd"
$ cd build
$ sudo modprobe nbd

3. Na pasta "build", dê make
$ make

4. Na pasta build, rode o programa
$ make run

5. (opcional) Abra outra aba no terminal e conecte ao qemu via telnet
$ telnet localhost 1234

5.1 (opcional) Veja os registradores
$ (qemu) info registers

5.2 (opcional) Fechar o programa
$ (qemu) q
