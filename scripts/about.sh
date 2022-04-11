#!/bin/sh
# Output some info about this system (Raspberry Pi).
# Save this info to /boot/about.txt to have it available
# when the SD card is read on Windows or macOS.
# Execute like this to save the output to /boot/about.txt (as root):
# $ ./about.sh | sudo tee /boot/about.txt

echo "# About this system..."
echo
date +%Y-%m-%d\ %H:%M
echo "$(whoami)@$(hostname)"
lsb_release -sd
uname -a
type Xorg
echo
df -h
echo

echo "Hardware:"
echo "$(cat /proc/device-tree/model)"
echo "MAC addresses:"
ip -o link show | cut -d ' ' -f 2,20 | grep --invert-match 'lo'
echo
free -h
echo
