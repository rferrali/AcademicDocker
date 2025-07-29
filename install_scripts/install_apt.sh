#!/bin/bash
set -e

echo "Installing apt packages..."
apt-get update
apt-get install -y --no-install-recommends \
    bash \
    curl \
    ca-certificates \
    git \
    build-essential \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    software-properties-common \
    wget \
    perl \
    pipx \
    nano \
    zsh
pipx ensurepath
# rm -rf /var/lib/apt/lists/*