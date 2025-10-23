#!/bin/bash
# compr.sh
# This script performs a deep compare of two folders.
# It does not make any changes, it is a read only operation.
# It compares every file by hash, not just size and dates.
# It uses rsync to perform the task. Output is basically the name of 
# any file that differs between source and target locations.
#
# Usage:
# compr <folder1> <folder2>

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
# Directory compare using rsync.
rsync -nvcrt --delete --exclude='._*' --exclude='.DS_Store' "${SRC}" "${DST}"
# Read timer
ELAPSED=$SECONDS
printf "Elapsed time: %02d:%02d:%02d\n" $((ELAPSED/3600)) $(( (ELAPSED%3600)/60 )) $((ELAPSED%60))
