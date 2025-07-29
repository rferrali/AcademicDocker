#! /bin/bash
set -e

chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -sS https://starship.rs/install.sh | sh -s -- --yes
