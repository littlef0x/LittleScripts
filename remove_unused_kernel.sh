#!/bin/bash
# Remove all kernels excluding newest one and the on in using

# List all kernels & exclude one in using, linux-image-generic, and newest one
kernel_version=$(dpkg --list | grep linux-image | grep -v `uname -r` | grep -v linux-image-generic | sed '$d' | awk '{print $2}' | awk -F '-' '{print $3"-"$4}')
# remove kernels in the list
echo $kernel_version | xargs -n 1 | xargs -I {} sudo apt purge -y ^linux.*{}.*