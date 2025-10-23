#!/bin/sh
# Prepare Python development environment.

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
	echo "You must run this script with root privileges."
	exit 1
fi

## Stuff to install __before__ installing Python.
apt install -y libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev
apt install -y libffi-dev python3-dev python3-smbus

