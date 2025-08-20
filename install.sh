#!/usr/bin/bash
set -euo pipefail

# Constants
LOCAL_BIN="$HOME/.local/bin"
GO_VERSION="1.24.6"
HELM_VERSION="3.18.5"

mkdir -p "$LOCAL_BIN"

sudo apt-get update
sudo apt-get install -y \
  build-essential procps curl file git unzip zsh fuse \
  gpg wget lsb-release

# https://www.jetify.com/devbox/docs/installing_devbox/
curl -fsSL https://get.jetify.com/devbox | bash

# Helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# eget
curl https://zyedidia.github.io/eget.sh | sh
TOOLS=(
  "go-task/task --asset amd64.tar.gz --to $LOCAL_BIN"
  "mirceanton/kubectl-switch --asset amd64.tar.gz --to $LOCAL_BIN"
  "neovim/neovim --asset x86_64 --to $LOCAL_BIN/nvim"
  "jesseduffield/lazygit --to $LOCAL_BIN"
)

for tool in "${TOOLS[@]}"; do
  "./eget" $tool
done
rm -rf eget

### ZSH
# Pure theme
if [[ ! -d "$HOME/.zsh/pure" ]]; then
  git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
fi

# ZSH Plugins
# zsh-autosuggestions
if [[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
  git -C "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" pull
else
  git clone https://github.com/zsh-users/zsh-autosuggestions.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# zsh-syntax-highlighting
if [[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
  git -C "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" pull
else
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
