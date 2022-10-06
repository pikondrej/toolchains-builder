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

set -ex

if [ "$#" -ne 1 ]; then
	echo "Usage:" >&2
	echo "  $0 armv5-eabi" >&2
	echo "  $0 armv7-eabihf" >&2
	echo "  $0 x86-i686" >&2
	exit 1
fi

tc_tag="2021.05"
tc_dir="$1--uclibc--stable-${tc_tag}"
tc_tar="$1--uclibc-backtrace-cortex_a7--stable-${tc_tag}.tar.bz2"

if [[ "$1" != armv5-eabi && "$1" != armv7-eabihf && "$1" != x86-i686 ]]; then
	echo "Unsupported platform" >&2
	exit 1
fi

if [ ! -d "./buildroot" ]; then
	git clone https://github.com/bootlin/buildroot-toolchains.git buildroot
fi

if [ -f "${tc_tar}" ]; then
	rm "${tc_tar}"
fi

cd buildroot
git clean -fdx
git checkout toolchains.bootlin.com-"${tc_tag}"

cat ../"$1"-uclibc-config > ./.config
cp ../uclibc-backtrace.fragment ./

make olddefconfig
make clean
make
make sdk

cp ../"$1"-readme.txt ./"${tc_dir}"
tar -cjf ../"${tc_tar}" "${tc_dir}"
