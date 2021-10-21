#!/bin/bash

# Copyright 2021
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in the
# Software without restriction, including without limitation the rights to use, copy,
# modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies
# or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
# PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
# FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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

if [ ! -d "./buildroot" ]; then
	git clone https://github.com/bootlin/buildroot-toolchains.git buildroot
fi

if [ -f "$1"--uclibc-backtrace--stable-2021.05.tar.bz2 ]; then
	rm "$1"--uclibc-backtrace--stable-2021.05.tar.bz2
fi

cd buildroot
git clean -fdx
git checkout toolchains.bootlin.com-stable-2021.5

cat ../"$1"-uclibc-config > ./.config
cp ../uclibc-backtrace.fragment ./

make olddefconfig
make clean
make
make sdk

cp ../"$1"-readme.txt ./"$1"--uclibc--stable-2021.05
tar -cjf ../"$1"--uclibc-backtrace--stable-2021.05.tar.bz2 "$1"--uclibc--stable-2021.5
