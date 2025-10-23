#!/bin/bash
# copyr.sh
# This script performs a deep copy of a folder.
# It is a one way operation where the target folder is
# synchronized with the source folder.
# It compares every file by hash, not just size and dates.
# It uses rsync to perform the task. 

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

# Directory copy using rsync (sync SRC to DST one way).
rsync -Wavh --progress "${SRC}" "${DST}"

# Read timer
ELAPSED=$SECONDS
printf "Elapsed time: %02d:%02d:%02d\n" $((ELAPSED/3600)) $(( (ELAPSED%3600)/60 )) $((ELAPSED%60))
