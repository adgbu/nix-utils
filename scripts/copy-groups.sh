#!/bin/bash
# copy-groups.sh
# This script will copy the group memberships from one user to another.
# Script must be run with root privileges!
# Example:
# Typical usage on Raspberry Pi is to copy from user "pi" to a new user.
# $ sudo ./copy-groups.sh pi newuser

if [[ -z "$1" ]]; then
	echo "You must provide the source username as the 1st parameter."
	exit 1
fi

# Get all group memberships of source username, except the personal group.
# Get the groups. Remove first 3 tokens. Replace spaces with commas.
clean_grouplist=$(groups $1 | awk '{for (i=4; i<=NF-1; i++) printf $i ","; print $NF}')
echo "$clean_grouplist"


if [[ -z "$2" ]]; then
	echo "You must provide the destination username as the 2nd parameter."
	exit 1
fi

# Add the group memberships to the other user.
usermod --append --groups $clean_grouplist $2
