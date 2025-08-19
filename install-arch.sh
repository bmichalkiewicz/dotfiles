#!/usr/bin/bash
set -euo pipefail

passwd root
useradd -m michab
passwd michab

pacman -Sy sudo
chmod 600 /etc/sudoers
sed -i 's/^#\s*\(%wheel\s*ALL=(ALL)\s*NOPASSWD:\s*ALL\)/\1/' /etc/sudoers
usermod -aG wheel michab

# Constants
LOCAL_BIN="$HOME/.local/bin"
GO_VERSION="1.24.6"
HELM_VERSION="3.18.5"

mkdir -p "$LOCAL_BIN"

pacman-key --init
pacman-key --populate
pacman-key --refresh-keys
pacman -Sy archlinux-keyring
pacman -Syyu
sudo pacman -S --needed --no-confirm \
  curl unzip zsh openssh base-devel \
  go-task go

# yay
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si
yay -Syu
rm -rf ~/yay-git

# https://www.jetify.com/devbox/docs/installing_devbox/
curl -fsSL https://get.jetify.com/devbox | bash

# Helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# kubectl-switch
go install github.com/mirceanton/kubectl-switch/v2@latest

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
