#!/usr/bin/bash
set -euo pipefail

# Source installation functions
source "$(dirname "$0")/lib/install.sh"

main() {
    echo "🚀 Starting dotfiles installation..."
    
    install_system_packages
    install_devbox
    install_helm
    install_tools
    install_docker
    install_aws_cli
    install_python_tools
    install_volta
    install_rust
    install_claude
    setup_zsh
    
    echo "✅ Installation complete!"
    echo "💡 Run 'devbox run sync' to sync your dotfiles"
}

main "$@"