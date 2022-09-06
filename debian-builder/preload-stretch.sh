#!/usr/bin/env bash

if [ "$(dpkg --print-architecture)" == "amd64" ]; then
	apt-get install -y --no-install-recommends -t stretch-backports linux-compiler-gcc-6-x86
fi

if [ "$(dpkg --print-architecture)" == "armhf" ]; then
	KERNELS=$(apt-cache search linux-headers | grep "^linux-headers-[45].*-armmp" | grep -v -- "-rt-armmp" | cut -f 1 -d ' ' | tr '\n' ' ')
	apt-get install -y $KERNELS
else
	KERNELS=$(apt-cache search linux-headers | grep "^linux-headers-[45].*-${ARCH}" | grep -v "all-${ARCH}" | grep -v -- "-rt-${ARCH}" | grep -v -- "-cloud-${ARCH}" | cut -f 1 -d ' ' | tr '\n' ' ')
	apt-get install -y $KERNELS
fi
