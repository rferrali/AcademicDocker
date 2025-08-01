#!/bin/bash

# Script to update R version across the project
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

echo "Updating R version to $NEW_R_VERSION..."

# Update Dockerfile
sed -i.bak "s/ARG R_VERSION=.*/ARG R_VERSION=$NEW_R_VERSION/" Dockerfile

# Update GitHub Actions workflow
sed -i.bak "s/R_VERSION: .*/R_VERSION: $NEW_R_VERSION  # Pin the R version here/" .github/workflows/docker-publish.yml

# Clean up backup files
rm -f Dockerfile.bak .github/workflows/docker-publish.yml.bak

echo "✅ Updated R version to $NEW_R_VERSION"
echo "📝 Files updated:"
echo "   - Dockerfile"
echo "   - .github/workflows/docker-publish.yml"
echo ""
echo "🚀 Commit and push these changes to trigger a new build with R $NEW_R_VERSION"
