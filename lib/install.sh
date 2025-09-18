#!/usr/bin/bash
set -euo pipefail

# Constants
GO_VERSION="1.24.6"
HELM_VERSION="3.18.5"
LOCAL_BIN="$HOME/.local/bin"

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

# Check if binary exists using bin tool
check_binary_exists() {
    local binary_name="$1"
    local package_name="${2:-$1}"  # Use binary name as package name if not provided

    # Check if binary is available in PATH
    if command -v "$binary_name" >/dev/null 2>&1; then
        echo "✓ $binary_name is already installed, skipping..."
        return 0  # exists
    fi

    # Also check if it's managed by bin tool
    if command -v bin >/dev/null 2>&1 && bin list 2>/dev/null | grep -q -e "$package_name\s"; then
        echo "✓ $package_name is already managed by bin, skipping..."
        return 0  # exists
    fi

    return 1  # doesn't exist
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
            echo " Unsupported OS: $OS"
            exit 1
            ;;
    esac
}

install_system_packages() {
    echo "📦 Installing system packages..."
    mkdir -p "${LOCAL_BIN}"

    detect_os
    case $OS_ID in
        arch|manjaro)
            install_packages curl git unzip stow
            ;;
        ubuntu|debian|pop)
            install_packages build-essential procps curl file git unzip zsh fuse \
                gpg wget lsb-release ca-certificates stow
            ;;
    esac
}

install_tools() {
    echo "🔧 Installing CLI tools..."

    # Install bin tool if not already installed
    if ! command -v bin >/dev/null 2>&1; then
        echo "📦 Installing bin tool manager..."
        if curl -L https://github.com/marcosnils/bin/releases/download/v0.23.1/bin_0.23.1_linux_amd64 --output bin; then
            chmod +x bin
            if ./bin install github.com/marcosnils/bin; then
                rm -rf ./bin
                echo "✓ bin tool manager installed successfully"
            else
                echo "❌ Failed to install bin tool manager"
                rm -rf ./bin
                return 1
            fi
        else
            echo "❌ Failed to download bin tool manager"
            return 1
        fi
    else
        echo "✓ bin tool manager already installed, skipping..."
    fi

    # Define tools with their binary names and GitHub repos
    declare -A tools_map=(
        ["task"]="go-task/task"
        ["kubectl-switch"]="mirceanton/kubectl-switch"
        ["nvim"]="neovim/neovim"
        ["lazygit"]="jesseduffield/lazygit"
        ["lazydocker"]="jesseduffield/lazydocker"
        ["gloner"]="bmichalkiewicz/gloner"
        ["uv"]="astral-sh/uv"
        ["argocd"]="argoproj/argo-cd"
        ["shellcheck"]="koalaman/shellcheck"
        ["tree-sitter"]="tree-sitter/tree-sitter"
        ["kind"]="kubernetes-sigs/kind"
        ["eza"]="eza-community/eza"
        ["jq"]="stedolan/jq"
        ["yq"]="mikefarah/yq"
        ["rg"]="BurntSushi/ripgrep"
        ["fd"]="sharkdp/fd"
        ["bat"]="sharkdp/bat"
        ["zoxide"]="ajeetdsouza/zoxide"
        ["fzf"]="junegunn/fzf"
        ["kubecolor"]="kubecolor/kubecolor"
        ["k9s"]="derailed/k9s"
        ["spf"]="yorukot/superfile"
        ["pug"]="leg100/pug"
        ["dyff"]="homeport/dyff"
    )

    # Install tools using bin if not already installed
    for binary_name in "${!tools_map[@]}"; do
        local repo="${tools_map[$binary_name]}"
        if ! check_binary_exists "$binary_name" "$repo"; then
            echo "📦 Installing $binary_name..."
            if ! bin install "github.com/$repo"; then
                echo "⚠️ Failed to install $binary_name, continuing with other tools..."
            fi
        fi
    done

    # Install HashiCorp tools
    if ! check_binary_exists "terraform"; then
        echo "📦 Installing terraform..."
        if ! bin install --provider hashicorp https://releases.hashicorp.com/terraform; then
            echo "⚠️ Failed to install terraform, continuing..."
        fi
    fi

    if ! check_binary_exists "packer"; then
        echo "📦 Installing packer..."
        if ! bin install --provider hashicorp https://releases.hashicorp.com/packer; then
            echo "⚠️  Failed to install packer, continuing..."
        fi
    fi
}

install_helm() {
    echo "⚓ Installing Helm..."
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}

install_kubectl() {
    if check_binary_exists "kubectl"; then
        return 0
    fi

    echo "☸️  Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl ~/.local/bin/kubectl
}

install_docker() {
    if check_binary_exists "docker"; then
        return 0
    fi

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
    if check_binary_exists "aws"; then
        return 0
    fi

    echo "☁️  Installing AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install --update
    rm -rf ./aws awscliv2.zip
}

install_python_tools() {
    echo "🐍 Installing Python tools..."

    echo "📦 Installing ansible..."
    $LOCAL_BIN/uv tool install ansible-core --with ansible

    echo "📦 Installing gita..."
    $LOCAL_BIN/uv tool install gita
}

install_volta() {
    echo "⚡ Installing Volta..."
    curl https://get.volta.sh | bash
}

install_claude() {
    if check_binary_exists "claude"; then
        return 0
    fi

    echo "🤖 Installing Claude CLI..."
    curl -fsSL claude.ai/install.sh | bash
}

setup_zsh() {
    echo "🐚 Setting up ZSH..."

    # Pure theme
    if [[ ! -d "$HOME/.zsh/pure" ]]; then
        echo "🎆 Installing Pure theme..."
        if ! git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"; then
            echo "⚠️  Failed to install Pure theme, continuing..."
        fi
    else
        echo "✓ Pure theme already installed, skipping..."
    fi

    # gita completion
    echo "📋 Installing gita completion..."
    if mkdir -p "$HOME/.zsh/completions/gita" && curl -o "$HOME/.zsh/completions/gita/_gita" https://raw.githubusercontent.com/nosarthur/gita/refs/heads/master/auto-completion/zsh/_gita; then
        echo "✓ gita completion installed successfully"
    else
        echo "⚠️  Failed to install gita completion, continuing..."
    fi

    # ZSH Plugins
    setup_zsh_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
    setup_zsh_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
}

setup_zsh_plugin() {
    local plugin_name="$1"
    local plugin_url="$2"
    local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin_name"

    if [[ -d "$plugin_dir" ]]; then
        echo "🔄 Updating $plugin_name plugin..."
        if ! git -C "$plugin_dir" pull; then
            echo "⚠️  Failed to update $plugin_name plugin, continuing..."
        fi
    else
        echo "📦 Installing $plugin_name plugin..."
        if ! git clone "$plugin_url" "$plugin_dir"; then
            echo "⚠️  Failed to install $plugin_name plugin, continuing..."
        fi
    fi
}
