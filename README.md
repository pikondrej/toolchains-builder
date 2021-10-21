# W&H Toolchains builder

This repo contains the configuration to build the toolchains for W&H processor:
* armv5-eabi
* armv7-eabihf
* x86-i686

## Build

To build the toolchain you can simply run the script passing the architecture name:
```shell
$ ./build.sh armv5-eabi
```
```shell
$ ./build.sh armv7-eabihf
```

Possible values of architecture are: armv5-eabi, armv7-eabihf and x86-i686

Optionally you can build the toolchains manually:
```shell
$ git clone https://github.com/bootlin/buildroot-toolchains.git buildroot
$ cd buildroot
$ git checkout toolchains.bootlin.com-stable-2018.11-1
$ cat ../<config>-uclibc-config > ./.config
$ cp ../uclibc-backatrace.fragment ./
$ make olddefconfig
$ make
```