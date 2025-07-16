#!/bin/bash

# Script to copy Armbian build outputs to the builds/ directory with proper naming
# Usage: ./copy_build.sh <phase_number> <description>
# Example: ./copy_build.sh 1 "display-support"

set -e

# Go to project root
cd "$(dirname "$0")/.."

if [ $# -ne 2 ]; then
    echo "Usage: $0 <phase_number> <description>"
    echo "Example: $0 1 display-support"
    exit 1
fi

PHASE_NUMBER="$1"
DESCRIPTION="$2"
TIMESTAMP=$(date +%Y%m%d-%H%M)
BUILD_NAME="phase${PHASE_NUMBER}-${TIMESTAMP}-${DESCRIPTION}"

# Armbian output directory
OUTPUT_DIR="repos_to_update/armbian-build-rg34xxsp-support-branch/output/images"

# Check if output directory exists
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Error: Armbian output directory not found: $OUTPUT_DIR"
    echo "Make sure you have run a successful Armbian build first."
    exit 1
fi

# Find the most recent .img.xz file
LATEST_IMAGE=$(find "$OUTPUT_DIR" -name "*.img.xz" -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2-)

if [ -z "$LATEST_IMAGE" ]; then
    echo "Error: No .img.xz files found in $OUTPUT_DIR"
    echo "Make sure your Armbian build completed successfully."
    exit 1
fi

# Create builds directory if it doesn't exist
mkdir -p builds

# Copy the image with the new name
DEST_FILE="builds/${BUILD_NAME}.img.xz"
cp "$LATEST_IMAGE" "$DEST_FILE"

# Get file size for reporting
FILE_SIZE=$(du -h "$DEST_FILE" | cut -f1)

echo "Build copied successfully!"
echo "Source: $LATEST_IMAGE"
echo "Destination: $DEST_FILE"
echo "Size: $FILE_SIZE"
echo ""
echo "This build can now be flashed with Balena Etcher or similar tools."
echo "Don't forget to commit this build to git:"
echo "git add $DEST_FILE && git commit -m \"Add Phase $PHASE_NUMBER build: $DESCRIPTION\""