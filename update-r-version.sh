#!/bin/bash

# Script to create a new R version release
# Usage: ./update-r-version.sh 4.5.2

if [ $# -eq 0 ]; then
    echo "Usage: $0 <R_VERSION>"
    echo "Example: $0 4.5.2"
    exit 1
fi

NEW_R_VERSION=$1

# Validate R version format (basic check)
if ! [[ $NEW_R_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: R version must be in format X.Y.Z (e.g., 4.5.1)"
    exit 1
fi

echo "Creating release for R version $NEW_R_VERSION..."

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Check if there are uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "Error: There are uncommitted changes. Please commit or stash them first."
    exit 1
fi

# Create and push the tag
TAG_NAME="v$NEW_R_VERSION"

echo "Creating tag: $TAG_NAME"
git tag -a "$TAG_NAME" -m "Release R version $NEW_R_VERSION"

echo "Pushing tag to trigger Docker build..."
git push origin "$TAG_NAME"

echo "✅ Created and pushed tag: $TAG_NAME"
echo "🚀 GitHub Actions will now build and push Docker images with:"
echo "   - ghcr.io/rferrali/academic-docker:$NEW_R_VERSION"
echo "   - ghcr.io/rferrali/academic-docker:latest"
echo ""
echo "� Monitor the build at: https://github.com/rferrali/AcademicDocker/actions"
