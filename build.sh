#!/bin/bash

set -e

if [ "$#" -ne 1 ]; then
	echo "Usage:" >&2
	echo "  $0 armv5-eabi" >&2
	echo "  $0 armv7-eabihf" >&2
	exit 1
fi

if [[ "$1" != armv5-eabi && "$1" != armv7-eabihf ]]; then
	echo "Unsupported platform" >&2
	exit 1
fi

git clone https://github.com/bootlin/buildroot-toolchains.git buildroot
cd buildroot
git checkout toolchains.bootlin.com-stable-2018.11-1

cat ../"$1"-uclibc-config > ./.config
cp ../uclibc-backatrace.fragment ./

make olddefconfig
make clean
make

cp ../"$1"-readme.txt ./"$1"--uclibc--stable-2018.11-1
tar -cjf "$1"--uclibc--stable-2018.11-1.tar.bz2 "$1"--uclibc-backtrace--stable-2018.11-1
mv "$1"--uclibc-backtrace--stable-2018.11-1.tar.bz2 ../