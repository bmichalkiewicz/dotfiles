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
  "jesseduffield/lazydocker --to $LOCAL_BIN"
  "bmichalkiewicz/gloner --to $LOCAL_BIN"
  "astral-sh/uv --asset gnu --to $LOCAL_BIN"
)

for tool in "${TOOLS[@]}"; do
  "./eget" $tool
done
rm -rf eget

# Docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# AWS cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --update
rm -rf ./aws awscliv2.zip

# uv
$LOCAL_BIN/uv tool install ansible-core --with ansible
$LOCAL_BIN/uv tool install gita

# gita
mkdir -p "$HOME/.zsh/completions" &&
  curl -o "$HOME/.zsh/completions/gita" https://raw.githubusercontent.com/nosarthur/gita/refs/heads/master/auto-completion/zsh/_gita

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

### ZSH
# Pure theme
if [[ ! -d "$HOME/.zsh/pure" ]]; then
  git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
fi

# K9s theme
OUT="${XDG_CONFIG_HOME:-$HOME/.config}/k9s/skins"
mkdir -p "$OUT"
curl -L https://github.com/catppuccin/k9s/archive/main.tar.gz | tar xz -C "$OUT" --strip-components=2 k9s-main/dist

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
  w git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
