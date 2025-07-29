#! /bin/bash
set -e

echo "Installing TinyTeX..."

curl -fsSL "https://yihui.org/tinytex/install-unx.sh" \
  | sh -s - --admin --no-path
