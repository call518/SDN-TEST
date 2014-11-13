#!/usr/bin/env bash

# Exit on any error (non-zero return code)
set -e

if test ! -f /swapfile; then
	# Create swapfile of 4GB with block size 1MB
	/bin/dd if=/dev/zero of=/swapfile bs=1024 count=4194304 2>&1

	# Create swapfile of 2GB with block size 1MB
	#/bin/dd if=/dev/zero of=/swapfile bs=1024 count=2097152 2>&1

	# Create swapfile of 1GB with block size 1MB
	#/bin/dd if=/dev/zero of=/swapfile bs=1024 count=1048576 2>&1

	# Set up the swap file
	/sbin/mkswap /swapfile
fi

# Enable swap file on every boot
if ! grep "^/swapfile"; then
	/bin/echo '/swapfile          swap            swap    defaults        0 0' >> /etc/fstab
fi

# Enable swap file immediately
if [ `free -m | grep :Swap | awk '{print $2}'` -eq 0 ]; then
	/sbin/swapon /swapfile
fi
