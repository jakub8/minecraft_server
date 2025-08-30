#!/bin/bash

# A script to merge multiple Minecraft resource packs into a single zip file.
# The order of the input packs matters: the first pack is the base,
# and each subsequent pack overrides the files of the previous ones.

# --- Script Usage ---
# ./merge_packs.sh [path/to/base_pack.zip] [path/to/overlay1.zip] ... [path/to/final_pack.zip]

# Check if enough arguments are provided (at least 2 inputs and 1 output)
if [ "$#" -lt 3 ]; then
  echo "Usage: $0 [base_pack] [overlay_pack1] ... [final_destination_pack]"
  echo "Example: $0 pack1.zip pack2.zip pack3.zip merged_pack.zip"
  exit 1
fi

# Get all arguments except the last one as the input packs
INPUT_PACKS=("${@:1:$#-1}")

# Get the very last argument as the output file path
OUTPUT_PACK="${!#}"

# Define a temporary directory for the merging process
TEMP_DIR="temp_pack_merge"

echo "Starting resource pack merge..."
echo "---------------------------------"

# Clean up any previous temporary directories to ensure a fresh start
if [ -d "$TEMP_DIR" ]; then
  echo "Removing previous temporary directory."
  rm -rf "$TEMP_DIR"
fi

# Create the temporary directory
mkdir "$TEMP_DIR"
cd "$TEMP_DIR" || exit

# Loop through and unzip each input pack in the order they were provided
for pack in "${INPUT_PACKS[@]}"; do
  if [ ! -f "../$pack" ]; then
    echo "Error: Input pack not found at '../$pack'"
    # Clean up before exiting
    cd ..
    rm -rf "$TEMP_DIR"
    exit 1
  fi
  echo "-> Unzipping: $pack"
  # Unzip the pack. The -o flag ensures it overwrites existing files without prompting.
  unzip -o "../$pack"
done

echo "---------------------------------"
echo "All packs unzipped. Creating the final merged archive..."

# Create the new, merged zip file from the contents of the temporary directory
zip -r "../$OUTPUT_PACK" .

echo "Successfully created: $OUTPUT_PACK"

# Clean up by removing the temporary directory
cd ..
rm -rf "$TEMP_DIR"

echo "Merge complete. Temporary files have been cleaned up."