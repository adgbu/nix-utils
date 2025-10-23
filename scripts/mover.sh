#!/bin/bash
# mover.sh
# This script moves a folder using rsync.

# Check that exactly two arguments are provided.
if [ "$#" -ne 2 ]; then
  echo "Usage:"
  echo "$0 <source_folder_with_slash/> <target_folder_with_slash/>"
  exit 1
fi

SRC="$1"
DST="$2"

# Check that both arguments end with a slash.
if [[ "${SRC}" != */ || "${DST}" != */ ]]; then
  echo "Error: Folders must end with a trailing slash (/)."
  exit 1
fi

# Start timer
SECONDS=0

# Move folder using rsync and checksum verification.
rsync -ah --progress --checksum --remove-source-files "${SRC}" "${DST}"

# Read timer
ELAPSED=$SECONDS
printf "Elapsed time: %02d:%02d:%02d\n" $((ELAPSED/3600)) $(( (ELAPSED%3600)/60 )) $((ELAPSED%60))
