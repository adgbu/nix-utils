#!/bin/bash
# This is a script to generate an empty image file for Raspberry Pi backups.
# The image will contain both a boot (FAT32) and a root (ext4) partition.
# The use of "Here Strings" <<< requires bash, not POSIX standard.

USAGE="./rpi-image-create.sh <image file> <size>"

if [[ -z "$1" ]]; then
	echo "The 1st parameter must be the image file to create."
	echo "Usage:"
	echo "${USAGE}"
	exit 1
fi
IMAGE="$2"

if [[ -z "$2" ]]; then
	echo "The 2nd parameter must be the size (e.g. "6G")."
	echo "Usage:"
	echo "${USAGE}"
	exit 1
fi
SIZE="$2"

if [[ -f "${IMAGE}" ]]; then
	echo "The image file already exists."
	exit 2
fi

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
	echo "You must run this script with root privileges."
	exit 3
fi


# This is the sequence of commands to perform in fdisk. What you would do manually.
FDISK_STEP_BY_STEP="
n      # Add new partition (boot).
p      # Make it a primary partition.
1      # Partition number.
       # Default - first sector.
+256M  # Partition size.
a      # Make partition bootable.
t      # Set partition type to:
c      # W95 FAT32 (LBA)
n      # Add new partition (root)
p      # Make it a primary partition.
2      # Partition number
       # Default - first sector
       # Default - last sector to fill rest of space.
p      # Print the new partition table.
w      # Write the new partition table to disk.
"
# Use sed to strip the comments and only keep the command at the start of each line.
FDISK_CMDS=$(sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' <<< "${FDISK_STEP_BY_STEP}")
#debug: echo "${FDISK_CMDS}"

# Create an empty image file of the requested size (either sparse or filled with zeros).
# alt 1. dd
#dd if=/dev/zero of=image.img iflag=fullblock bs=5G count=1
# alt 2. Preallocate a file filled with 0s (not sparse).
#fallocate -l "${SIZE}" "${IMAGE}"
# alt 3. Create a empty sparse file.
truncate -s "${SIZE}" "${IMAGE}"

# Create a loopback block device, so we can access it like a disk.
DEVICE=$(losetup -fP --show "${IMAGE}")
#debug: echo $DEVICE

# Run fdisk with our list of commands.
# Use options "-c -u" to ensure alignment of blocks. This requires fdisk >= 2.17.1.
fdisk -c -u "${DEVICE}" <<< "${FDISK_CMDS}"

# Release the loopback block device.
losetup -d "${DEVICE}"

# Now we need block devices for each partition inside the image file.
DEVICE=$(losetup --partscan --find --show "${IMAGE}")

# Initialise the partitions with the appropriate file systems.
mkfs.fat -F 32 "${DEVICE}"p1
mkfs.ext4 "${DEVICE}"p2
lsblk --fs "${DEVICE}"

# Release the loopback block device.
losetup -d "${DEVICE}"
