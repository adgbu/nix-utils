#!/bin/bash
# This is a script to backup the current system to a mounted disk image.
# The backup destinations must be mounted as /mnt/boot and /mnt/root.
# Use the companion scripts to create and mount the image first.
# The use of "Here Strings" <<< requires bash, not POSIX standard.

USAGE="./rpi-image-rsync.sh <image file> <exclude list>"

if [[ -z "$1" ]]; then
	echo "The 1st parameter must be the file name of a backup image."
	echo "Usage:"
	echo "${USAGE}"
	exit 1
fi
IMAGE="$1"

if [[ -z "$2" ]]; then
	echo "The 2nd parameter must be the rsync exclude list."
	echo "Usage:"
	echo "${USAGE}"
	exit 2
fi
EXCL="$2"

# Confirm that rsync-exclude file exists.
if [[ ! -f "${EXCL}" ]]; then
	echo "The rsync exclude list '${EXCL}' does not exist."
	exit 3
fi

# Check if /mnt/boot and /mnt/root are mount points.
mountpoint -q "/mnt/boot"
if [ $? -ne 0 ]; then
	echo "/mnt/boot is not a mount point."
	exit 4
fi
mountpoint -q "/mnt/root"
if [ $? -ne 0 ]; then
	echo "/mnt/root is not a mount point."
	exit 4
fi

# Check if we have root privileges.
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
	echo "You must run this script with root privileges."
	exit 5
fi

echo "Let's rsync!"
CMD="rsync -avH --delete-during --delete-excluded --exclude='${IMAGE}' --exclude-from='${EXCL}' /boot/ /mnt/boot/"
echo "${CMD}"
eval "${CMD}"

CMD="rsync -avH --delete-during --delete-excluded --exclude='${IMAGE}' --exclude-from='${EXCL}' / /mnt/root/"
echo "${CMD}"
eval "${CMD}"
