#!/bin/bash

# Script to remove all repositories from repos_reference and repos_to_update directories
# This allows for a clean slate before re-cloning repositories

set -e

echo "Cleaning repository directories..."

# Remove all contents from repos_reference
if [ -d "repos_reference" ]; then
    echo "Removing all repositories from repos_reference/..."
    rm -rf repos_reference/*
    echo "repos_reference/ cleaned"
else
    echo "repos_reference/ directory does not exist"
fi

# Remove all contents from repos_to_update
if [ -d "repos_to_update" ]; then
    echo "Removing all repositories from repos_to_update/..."
    rm -rf repos_to_update/*
    echo "repos_to_update/ cleaned"
else
    echo "repos_to_update/ directory does not exist"
fi

echo "Repository cleanup complete!"
echo ""
echo "To restore repositories, run: ./restore_repos.sh"