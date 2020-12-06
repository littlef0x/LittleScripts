#!/bin/bash
# Remove all kernels excluding newest one and the on in using

used_disk=$(df -h | grep /boot | awk '{print $5}' | awk -F '%' '{print $1}')
if [[ $used_disk -lt 80 ]]; then
	echo 'Enough space for /boot.'
	exit 1
fi

# List all kernels & exclude one in using, linux-image-generic, and newest one
kernel_version=$(dpkg --list | grep linux-image | grep -v `uname -r` | grep -v linux-image-generic | sed '$d' | awk '{print $2}' | awk -F '-' '{print $3"-"$4}')
# remove kernels in the list
echo $kernel_version | xargs -n 1 | xargs -I {} sudo apt purge -y ^linux.*{}.*