#!/bin/bash
set -e
echo "Installing R..."

if [ "$TARGETARCH" = "amd64" ]; then
  ARCH="x86_64"
elif [ "$TARGETARCH" = "arm64" ]; then
  ARCH="aarch64"
else
  echo "Unknown architecture $TARGETARCH"
  exit 1
fi

curl -LO https://github.com/r-lib/rig/releases/download/latest/rig-linux-$ARCH-latest.tar.gz
tar xz -C /usr/local -f rig-linux-$ARCH-latest.tar.gz
rm rig-linux-$ARCH-latest.tar.gz
rig add release

curl -LO https://quarto.org/download/latest/quarto-linux-$TARGETARCH.deb
apt-get install -y ./quarto-linux-$TARGETARCH.deb
rm quarto-linux-$TARGETARCH.deb

R -e "pak::pkg_install(c('renv'))"
R -e "pak::pkg_install(c('knitr', 'rmarkdown'))"

pipx install radian
