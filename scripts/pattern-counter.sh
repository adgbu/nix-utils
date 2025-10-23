#!/bin/bash

# Check if at least one pattern argument is provided.
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <pattern1> [<pattern2> ... <patternN>]"
  echo "pattern-counter summarizes repeating occurrences of pattern into a count."
  echo ""
  echo "Example usage together with tree or ls command:"
  echo "tree | pattern-counter.sh .jpg .JPG .jpeg"
  exit 1
fi

# Initialize the acc array for each pattern
num_patterns=$#+1
acc=()
for ((i=0; i<num_patterns; i++)); do
  acc[i]=0
#  echo "Pattern $i is '${!i}'"
done

total=0
# Read input from stdin line by line
while IFS= read -r line; do
  match=0
  for ((i=1; i<num_patterns; i++)); do
    pattern="${!i}"
    if [[ "$line" == *"$pattern"* ]]; then
      # Increment the acc for the pattern if found
      ((acc[i]+=1))
      ((total+=1))
      ((match+=1))
    fi
  done

  if [[ ${match} -eq 0 ]]; then
    # Print the acc values and reset them
    for ((i=1; i<num_patterns; i++)); do
      if [[ ${acc[i]} -ne 0 ]]; then
        echo "... ${acc[i]} occurrences of '${!i}'"
        acc[i]=0
      fi
    done
    # Print the current line
    echo "$line"
  fi
done

# Print the final acc values if the last lines contained the patterns.
for ((i=1; i<num_patterns; i++)); do
  if [[ ${acc[i]} -ne 0 ]]; then
    echo "... ${acc[i]} occurrences of '${!i}'"
  fi
done

