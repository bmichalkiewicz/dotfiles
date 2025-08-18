#!/usr/bin/bash
set -euo pipefail

# Constants
LOCAL_BIN="$HOME/.local/bin"
GO_VERSION="1.24.6"

mkdir -p "$LOCAL_BIN"

sudo apt-get update
sudo apt-get install -y \
  build-essential procps curl file git unzip zsh fuse \
  gpg wget lsb-release

# https://www.kcl-lang.io/docs/user_docs/getting-started/install#linux-1
wget -q https://kcl-lang.io/script/install-kcl-lsp.sh -O - | /bin/bash

# https://www.jetify.com/devbox/docs/installing_devbox/
curl -fsSL https://get.jetify.com/devbox | bash

# https://github.com/zyedidia/eget
bash -c "$(curl -fsSL https://zyedidia.github.io/eget.sh)"
mv eget "$LOCAL_BIN"

TOOLS=(
  "hidetatz/kubecolor"
  "sharkdp/bat --asset gnu"
  "yorukot/superfile"
  "derailed/k9s --asset amd64.tar.gz --asset ^sbom"
  "go-task/task --asset amd64.tar.gz"
  "mikefarah/yq --asset amd64 --asset ^tar.gz"
  "mirceanton/kubectl-switch --asset amd64.tar.gz"
  "junegunn/fzf"
  "neovim/neovim --asset x86_64"
  "BurntSushi/ripgrep"
  "sharkdp/fd --asset gnu"
  "jesseduffield/lazygit"
)
for tool in "${TOOLS[@]}"; do
  "$LOCAL_BIN/eget" $tool --to "$LOCAL_BIN"
done

### Terraform + Packer
wget -qO- https://apt.releases.hashicorp.com/gpg |
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" |
  sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt-get install -y terraform packer

### Go
wget "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -O "/tmp/go.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf /tmp/go.tar.gz

# neovim
mv $LOCAL_BIN/nvim-linux-x86_64 $LOCAL_BIN/nvim
