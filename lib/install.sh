#!/usr/bin/bash
set -euo pipefail

# Constants
LOCAL_BIN="$HOME/.local/bin"
GO_VERSION="1.24.6"
HELM_VERSION="3.18.5"

# OS detection
detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS=$NAME
        OS_ID=$ID
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
        OS_ID=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
    else
        OS=$(uname -s)
        OS_ID=$(uname -s | tr '[:upper:]' '[:lower:]')
    fi
}

# Package manager wrapper
install_packages() {
    detect_os
    case $OS_ID in
        arch|manjaro)
            sudo pacman -S --needed --noconfirm "$@"
            ;;
        ubuntu|debian|pop)
            sudo apt-get update
            sudo apt-get install -y "$@"
            ;;
        *)
            echo "❌ Unsupported OS: $OS"
            exit 1
            ;;
    esac
}

install_system_packages() {
    echo "📦 Installing system packages..."
    detect_os
    case $OS_ID in
        arch|manjaro)
            install_packages curl git unzip
            ;;
        ubuntu|debian|pop)
            install_packages build-essential procps curl file git unzip zsh fuse \
                gpg wget lsb-release ca-certificates
            ;;
    esac
}

install_devbox() {
    echo "📦 Installing devbox..."
    curl -fsSL https://get.jetify.com/devbox | bash
}

install_tools() {
    echo "🔧 Installing CLI tools..."
    mkdir -p "$LOCAL_BIN"
    
    # eget for downloading tools
    curl https://zyedidia.github.io/eget.sh | sh
    
    local tools=(
        "go-task/task --asset amd64.tar.gz --to $LOCAL_BIN"
        "mirceanton/kubectl-switch --asset amd64.tar.gz --to $LOCAL_BIN"
        "neovim/neovim --asset x86_64 --to $LOCAL_BIN/nvim"
        "jesseduffield/lazygit --to $LOCAL_BIN"
        "jesseduffield/lazydocker --to $LOCAL_BIN"
        "bmichalkiewicz/gloner --to $LOCAL_BIN"
        "astral-sh/uv --asset gnu --to $LOCAL_BIN"
        "argoproj/argo-cd --to $LOCAL_BIN"
        "koalaman/shellcheck --to $LOCAL_BIN"
    )

    for tool in "${tools[@]}"; do
        "./eget" $tool
    done
    rm -rf eget
}

install_helm() {
    echo "⎈ Installing Helm..."
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}

install_docker() {
    echo "🐳 Installing Docker..."
    detect_os
    case $OS_ID in
        arch|manjaro)
            install_packages docker docker-compose
            sudo systemctl enable docker.service
            sudo systemctl enable containerd.service
            ;;
        ubuntu|debian|pop)
            # Add Docker's official GPG key
            sudo install -m 0755 -d /etc/apt/keyrings
            sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
            sudo chmod a+r /etc/apt/keyrings/docker.asc

            # Add the repository to Apt sources
            echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
              $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
                sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

            sudo apt-get update
            sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;
    esac
}

install_aws_cli() {
    echo "☁️ Installing AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install --update
    rm -rf ./aws awscliv2.zip
}

install_python_tools() {
    echo "🐍 Installing Python tools..."
    $LOCAL_BIN/uv tool install ansible-core --with ansible
    $LOCAL_BIN/uv tool install gita
}

install_volta() {
    echo "⚡ Installing Volta..."
    curl https://get.volta.sh | bash
    volta install node
}

install_rust() {
    echo "🦀 Installing Rust..."
    curl https://sh.rustup.rs -sSf | sh
}

install_claude() {
    echo "🤖 Installing Claude CLI..."
    curl -fsSL claude.ai/install.sh | bash
}

setup_zsh() {
    echo "🐚 Setting up ZSH..."
    
    # Pure theme
    if [[ ! -d "$HOME/.zsh/pure" ]]; then
        git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
    fi

    # K9s theme
    local k9s_out="${XDG_CONFIG_HOME:-$HOME/.config}/k9s/skins"
    mkdir -p "$k9s_out"
    curl -L https://github.com/catppuccin/k9s/archive/main.tar.gz | tar xz -C "$k9s_out" --strip-components=2 k9s-main/dist

    # gita completion
    mkdir -p "$HOME/.zsh/completions/gita" &&
    curl -o "$HOME/.zsh/completions/gita/_gita" https://raw.githubusercontent.com/nosarthur/gita/refs/heads/master/auto-completion/zsh/_gita

    # ZSH Plugins  
    setup_zsh_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
    setup_zsh_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
}

setup_zsh_plugin() {
    local plugin_name="$1"
    local plugin_url="$2"
    local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin_name"
    
    if [[ -d "$plugin_dir" ]]; then
        git -C "$plugin_dir" pull
    else
        git clone "$plugin_url" "$plugin_dir"
    fi
}
