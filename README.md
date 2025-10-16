# 🏠 Dotfiles

A comprehensive development environment setup using GNU Stow for dotfile management with modern tools and configurations, designed especially for WSL (Windows Subsystem for Linux) on Debian/Ubuntu systems.

## 🚀 Features

### 🛠️ Development Tools
- **Languages & Runtimes**: Go, Node.js (via Volta), Python (via uv)
- **Version Control**: Git with optimized configuration
- **Containers**: Docker with docker-compose
- **Kubernetes**: kubectl, helm, kind, k9s with themes
- **CLI Tools**: lazygit, lazydocker, task, fzf, eza, bat
- **Terminal**: Modern ZSH setup with Oh My Zsh and plugins
- **Editor**: Neovim configuration

### 🎨 Terminal Configuration
- **Shell**: ZSH with Oh My Zsh framework
- **Theme**: Pure prompt theme
- **Plugins**: Auto-suggestions, syntax highlighting, git integration
- **Aliases**: Optimized shortcuts for common commands
- **History**: Enhanced history management

### 🖥️ Terminal Applications
- **WezTerm**: Modern GPU-accelerated terminal with Gruvbox theme
- **VS Code**: Developer-optimized settings

### ☁️ Cloud & DevOps
- **AWS CLI**: Latest version with configuration
- **Ansible**: Infrastructure automation
- **GNU Stow**: Symlink management for dotfiles
- **gita**: Multi-repository management

## 📋 Prerequisites

- Debian/Ubuntu-based Linux distribution (WSL recommended)
- **JetBrains Mono Nerd Font** (required for proper icon display in terminal)
- Internet connection for downloading packages
- `sudo` privileges for system package installation

### Font Installation

Install JetBrains Mono Nerd Font from [Nerd Fonts releases](https://github.com/ryanoasis/nerd-fonts/releases):

```bash
# On WSL, download and install on Windows side, then configure WezTerm to use it
# Font name: "JetBrains Mono Nerd Font"
```

## 🔧 Installation

### Quick Setup

1. **Install Oh My Zsh** (if not already installed):
```bash
sudo apt update
sudo apt install -y curl git zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

2. **Clone and install dotfiles**:
```bash
cd ~
git clone https://github.com/bmichalkiewicz/dotfiles.git
cd ~/dotfiles
chmod +x ./install.sh && ./install.sh
```

3. **Sync configurations using GNU Stow**:
```bash
rm ~/.zshrc
stow --no-folding .
```

4. **Reload your shell**:
```bash
source ~/.zshrc
```

### Manual Step-by-Step Installation

If you prefer to understand what each step does:

1. **System packages**: Updates system and installs build essentials, curl, git, etc.
2. **GNU Stow**: Installs Stow for dotfile symlink management
3. **CLI tools**: Downloads modern alternatives (eza, bat, lazygit, etc.)
4. **Docker**: Installs Docker CE with compose plugin
5. **Cloud tools**: AWS CLI, Helm, kubectl
6. **Language runtimes**: Volta (Node.js), Rust, Python tools
7. **Shell setup**: Configures ZSH with themes and plugins
8. **Configuration sync**: Uses GNU Stow to symlink dotfiles

## 📁 File Structure

```
dotfiles/
├── .zshrc              # ZSH configuration with plugins and aliases
├── .gitconfig          # Git global configuration
├── .kube/              # Kubernetes configuration
├── aliases.zsh         # Custom command aliases
├── .stow-local-ignore  # Files to exclude from Stow symlinking
├── install.sh          # Main installation script
├── lib/
│   └── install.sh      # Installation functions library
└── confs/
    ├── wezterm.lua     # WezTerm terminal configuration
    └── vsc.json        # VS Code settings
```

## 🎯 Key Aliases

### File Operations
- `ls` → `eza` with icons, colors, and git integration
- `la` → `eza --all` (show hidden files)
- `lg` → `eza --git-ignore --all` (respect gitignore)
- `tree` → `eza --tree` (tree view)
- `trea` → `eza --all --tree` (tree view with hidden)
- `cat` → `bat` with syntax highlighting

### Vim/Editor
- `fim` → `fzf --multi --bind "enter:become(nvim {})"` (fuzzy find and edit)

### Git Shortcuts
- `g` → `git`
- `ga` → `git add`
- `gc` → `git commit`
- `gs` → `git status`
- `gd` → `git diff`
- `gst` → `git stash`
- `gsp` → `git stash pop`
- `gch` → `git checkout`
- `gp` → `git pull`
- `gps` → `git push`
- `lg` → `lazygit`

### Kubernetes
- `k` → `kubecolor` (colorized kubectl)
- `kns` → `kubectl-switch ns` (namespace switcher)
- `kctx` → `kubectl-switch ctx` (context switcher)

### ArgoCD
- `ac` → `argo-cd`

### Terraform
- `tf` → `terraform`
- `tfp` → `terraform plan`
- `tfa` → `terraform apply`

### WSL Integration
- `open` → `explorer.exe` (open current directory in Windows Explorer)

## 🔍 What Gets Installed

### System Packages
- build-essential, curl, git, zsh, unzip
- GPG tools and certificates for secure downloads

### Development Tools
| Tool | Purpose |
|------|---------|
| **bin** | GitHub release downloader and binary manager |
| **task** | Task runner (Taskfile.yml) |
| **kubectl-switch** | Kubernetes context/namespace switcher |
| **neovim** | Modern Vim editor |
| **lazygit** | Terminal UI for git |
| **lazydocker** | Terminal UI for Docker |
| **uv** | Fast Python package installer |
| **jq/yq** | JSON/YAML processors |
| **eza** | Modern replacement for ls |
| **bat** | Cat clone with syntax highlighting |
| **fzf** | Fuzzy finder |
| **ripgrep (rg)** | Fast grep alternative |
| **fd** | Fast find alternative |
| **zoxide** | Smarter cd command |

### Language Runtimes
- **Volta**: Node.js version manager
- **Go**: Set up in PATH configuration
- **Python**: Enhanced with uv tool

## 🎨 Theming

The dotfiles use a consistent **Gruvbox** color scheme across:
- WezTerm terminal
- Superfile file manager
- Bat syntax highlighting
- ZSH syntax highlighting

## 🔧 Customization

### Adding Your Own Configurations

1. **Modify existing configs**: Edit files directly in the dotfiles directory
2. **Add new dotfiles**: Place them in the root directory and they'll be linked by `stow`
3. **Extend installation**: Add functions to `lib/install.sh`
4. **Custom aliases**: Add to `aliases.zsh`

### Environment Variables

The `.zshrc` sets up:
- `VOLTA_HOME`: Node.js version manager
- `GOPATH`: Go workspace
- `GIT_PATH`: Git repositories location
- `KUBECONFIG_DIR`: Kubernetes config directory

## 🚨 Troubleshooting

### Common Issues

1. **Permission denied**: Ensure `install.sh` is executable: `chmod +x install.sh`
2. **Stow conflicts**: Remove existing dotfiles before running `stow --no-folding .`
3. **ZSH not default**: Run `chsh -s $(which zsh)` to set as default shell
4. **Missing dependencies**: Ensure GNU Stow is installed: `sudo apt install stow`

### Verification

Check if tools are installed correctly:
```bash
# Verify installations
stow --version
docker --version
aws --version
kubectl version --client
git --version
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add some amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📜 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/) for the ZSH framework
- [Gruvbox](https://github.com/morhetz/gruvbox) for the beautiful color theme
- [GNU Stow](https://www.gnu.org/software/stow/) for dotfile management
- [JetBrains Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts) for excellent terminal typography
- All the amazing tool creators that make development better

---

**Happy coding!** 🎉
