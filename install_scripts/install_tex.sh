#! /bin/bash
set -e

echo "Installing TinyTeX..."

curl -fsSL "https://yihui.org/tinytex/install-unx.sh" \
  | sh -s - --admin --no-path
if [ "$TARGETARCH" = "amd64" ]; then
    ln -sf /root/.TinyTeX/bin/x86_64-linux /root/.TinyTeX/bin/current-arch
elif [ "$TARGETARCH" = "arm64" ]; then
    ln -sf /root/.TinyTeX/bin/aarch64-linux /root/.TinyTeX/bin/current-arch
else
    echo "Unknown architecture $TARGETARCH"
    exit 1
fi
