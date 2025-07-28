#! /bin/bash
set -e

# cleanup this folder after the script is done
mkdir -p /tmp/texlive
cd /tmp/texlive
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -xzf install-tl-unx.tar.gz --strip-components=1

./install-tl \
  -scheme=scheme-small \
  -no-interaction

apt-get update && apt-get install -y latexmk
