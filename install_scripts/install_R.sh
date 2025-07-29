#!/bin/bash
set -e
echo "Installing R..."

curl -LO https://github.com/r-lib/rig/releases/download/latest/rig-linux-aarch64-latest.tar.gz \
  && tar xz -C /usr/local -f rig-linux-aarch64-latest.tar.gz \
  && rm rig-linux-aarch64-latest.tar.gz \
  && rig add release

curl -LO https://quarto.org/download/latest/quarto-linux-arm64.deb \
    && apt-get install -y ./quarto-linux-arm64.deb \
    && rm quarto-linux-arm64.deb

R -e "pak::pkg_install(c('renv'))"
R -e "pak::pkg_install(c('knitr', 'rmarkdown'))"

pipx install radian
