#!/bin/bash

# Script to restore all repositories by cloning them from their original sources
# Run this after clean_repos.sh to restore the development environment
# Now supports updating existing repositories instead of just cloning

set -e

echo "Restoring repository directories..."

# Go to project root
cd "$(dirname "$0")/.."

# Create directories if they don't exist
mkdir -p repos_reference
mkdir -p repos_to_update

echo "Setting up repositories in repos_reference/..."

# Function to clone or update a repository
clone_or_update() {
    local url=$1
    local dir=$2
    local branch=${3:-main}
    
    if [ -d "$dir" ]; then
        echo "Updating existing repository: $dir"
        cd "$dir"
        git fetch origin
        git checkout "$branch" 2>/dev/null || git checkout "main" 2>/dev/null || git checkout "master" 2>/dev/null || true
        git pull origin HEAD
        cd ..
    else
        echo "Cloning new repository: $dir"
        git clone "$url" "$dir"
    fi
}

# Clone/update all reference repositories
cd repos_reference

clone_or_update "https://github.com/mporrato/alpine-h700" "alpine-h700"
clone_or_update "https://github.com/armbian/build" "armbian-build"
clone_or_update "https://github.com/knulli-cfw/distribution.git" "knulli-distribution"
clone_or_update "https://github.com/MustardOS/core.git" "muos-core"
clone_or_update "https://github.com/MustardOS/internal.git" "muos-internal"
clone_or_update "https://github.com/ROCKNIX/distribution" "rocknix-distribution"
clone_or_update "https://github.com/armbian/sunxi-DT-overlays" "sunxi-dt-overlays"

cd ..

echo "Setting up repositories in repos_to_update/..."

# Clone/update working repositories
cd repos_to_update

if [ -d "armbian-build-rg34xxsp-support-branch" ]; then
    echo "Updating existing development repository..."
    cd armbian-build-rg34xxsp-support-branch
    git fetch origin
    git fetch upstream 2>/dev/null || git remote add upstream https://github.com/armbian/build.git && git fetch upstream
    
    # Check if we're on the development branch
    current_branch=$(git branch --show-current)
    if [ "$current_branch" != "rg34xxsp-support" ]; then
        git checkout rg34xxsp-support 2>/dev/null || git checkout -b rg34xxsp-support
    fi
    
    echo "Updated development repository"
    cd ..
else
    echo "Cloning armbian-build for development..."
    git clone https://github.com/armbian/build.git armbian-build-rg34xxsp-support-branch
    
    echo "Setting up development branch..."
    cd armbian-build-rg34xxsp-support-branch
    git remote add upstream https://github.com/armbian/build.git
    git checkout -b rg34xxsp-support
    echo "Created and switched to 'rg34xxsp-support' branch"
    cd ..
fi

cd ..

echo "Repository restoration complete!"
echo ""
echo "Reference repositories are in: repos_reference/"
echo "Working repositories are in: repos_to_update/"
echo "Development branch 'rg34xxsp-support' ready in: repos_to_update/armbian-build-rg34xxsp-support-branch/"
echo ""
echo "To clean repositories again, run: ./helper_scripts/clean_repos.sh"