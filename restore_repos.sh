#!/bin/bash

# Script to restore all repositories by cloning them from their original sources
# Run this after clean_repos.sh to restore the development environment

set -e

echo "Restoring repository directories..."

# Create directories if they don't exist
mkdir -p repos_reference
mkdir -p repos_to_update

echo "Cloning repositories to repos_reference/..."

# Clone all reference repositories
cd repos_reference

echo "Cloning alpine-h700..."
git clone https://github.com/mporrato/alpine-h700

echo "Cloning armbian-build..."
git clone https://github.com/armbian/build armbian-build

echo "Cloning knulli-distribution..."
git clone https://github.com/knulli-cfw/distribution.git knulli-distribution

echo "Cloning linux-kernel..."
git clone https://github.com/torvalds/linux linux-kernel

echo "Cloning muos-core..."
git clone https://github.com/MustardOS/core.git muos-core

echo "Cloning muos-internal..."
git clone https://github.com/MustardOS/internal.git muos-internal

echo "Cloning rocknix-distribution..."
git clone https://github.com/ROCKNIX/distribution rocknix-distribution

echo "Cloning sunxi-dt-overlays..."
git clone https://github.com/armbian/sunxi-DT-overlays sunxi-dt-overlays

cd ..

echo "Cloning repositories to repos_to_update/..."

# Clone working repositories
cd repos_to_update

echo "Cloning armbian-build for development..."
git clone https://github.com/armbian/build.git armbian-build-rg34xxsp-support-branch

echo "Setting up development branch..."
cd armbian-build-rg34xxsp-support-branch
git remote add upstream https://github.com/armbian/build.git
git checkout -b rg34xxsp-support
echo "Created and switched to 'rg34xxsp-support' branch"

cd ../..

echo "Repository restoration complete!"
echo ""
echo "Reference repositories are in: repos_reference/"
echo "Working repositories are in: repos_to_update/"
echo "Development branch 'rg34xxsp-support' ready in: repos_to_update/armbian-build-rg34xxsp-support-branch/"
echo ""
echo "To clean repositories again, run: ./clean_repos.sh"