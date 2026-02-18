#!/bin/sh


# Function to convert mask to CIDR notation.
# e.g. "255.255.255.0" to "/24".
mask_to_cidr() {
    local mask="$1"
    local bits=$(echo "$mask" | awk -F. '{for(i=1;i<=4;i++){while($i){c+=($i%2);$i=int($i/2)}}} END{print c}')
    echo "$bits"
}


# Discover the primary network interface.
PIF=$(route get default | awk '/interface:/ {print $2}')

ADDR=$(ipconfig getifaddr "$PIF")
MASK=$(ipconfig getoption "$PIF" subnet_mask)

# Convert network mask (e.g. "255.255.255.0") to CIDR notation (e.g. "/24").
#CIDR=$(echo "$MASK" | awk -F. '{for(i=1;i<=4;i++) {while($i){c+=($i%2);$i=int($i/2)}}} END{print c}')
CIDR=$(mask_to_cidr "$MASK")

echo "$ADDR/$CIDR"
