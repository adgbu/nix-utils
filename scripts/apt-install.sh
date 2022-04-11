#!/bin/bash
# This script will invoke 'sudo apt install' but also log the selected packets to a file in your home directory.
# It makes it easy over time to keep track of everything that you have requested to install (and not see dependencies).
# Alias in .bash_aliases: alias install='~/rpi-utils/scripts/apt-install.sh'
# Usage: install <pkg1> [pkg2] [pkg3]
TIME=$(date +%Y-%m-%d\ %H:%M)
ARGS="install $@"
echo [$TIME] $ARGS | tee --append ~/log/apt-install.log
sudo apt $ARGS
