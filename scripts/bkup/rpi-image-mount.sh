#!/bin/bash
# This is a script to mount a Raspberry Pi backup image so we can write to it.
# The two partitions in the image will be mounted as /mnt/boot and /mnt/root.
# The use of "Here Strings" <<< requires bash, not POSIX standard.

USAGE="./rpi-image-mount.sh <image file>"

if [[ -z "$1" ]]; then
	echo "The 1st parameter must be the file name of a backup image."
	echo "Usage:"
	echo "${Usage}"
	exit 1
fi
IMAGE="$1"

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
	echo "You must run this script with root privileges."
	exit 2
fi

# Create mount points if they don't already exist.
[[ ! -d "/mnt/boot" ]] && mkdir /mnt/boot
[[ ! -d "/mnt/root" ]] && mkdir /mnt/root

# Unmount any existing mount. Hide error when this was redundant.
umount /mnt/boot 2>/dev/null
umount /mnt/root 2>/dev/null

# Now we need block devices for each partition, not the entire image.
DEVICE=$(sudo losetup --partscan --find --show "${IMAGE}")
#lsblk --fs "${DEVICE}"

mount "${DEVICE}"p1 /mnt/boot
mount "${DEVICE}"p2 /mnt/root

df -h | grep "/mnt/boot"
df -h | grep "/mnt/root"

# Release the loopback block device.
#sudo losetup -d "${DEVICE}"
