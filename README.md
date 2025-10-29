# 🏠 Dotfiles

My dotfiles designed specifically for WSL

## 🚀 Features

### 🛠️ Development Tools

- **Languages & Runtimes**: Go, Node.js (via Volta), Python (via uv)
- **Kubernetes**: kubectl/kubecolor, helm, kind, k9s
- **CLI Tools**: lazygit, lazydocker, task, fzf, eza, bat
- \*_Terminal_: Oh My Zsh and plugins
- **Editor**: Neovim

### 🎨 Terminal Configuration

- **Theme**: Pure prompt theme
- **Plugins**: Auto-suggestions, syntax highlighting

### 🖥️ Terminal Applications

- **WezTerm**

### ☁️ Cloud & DevOps

- **AWS CLI**
- **Ansible**
- **gita**: Multi-repository management

## 📋 Prerequisites

- Debian/Ubuntu WSL
- **JetBrains Mono Nerd Font** (required for proper icon display in terminal)

### Font Installation

Install JetBrains Mono Nerd Font from [Nerd Fonts releases](https://github.com/ryanoasis/nerd-fonts/releases):

```bash
# On WSL, download and install on Windows side, then configure WezTerm to use it
# Font name: "JetBrains Mono Nerd Font"
```

## 🔧 Installation

### Quick Setup

1. **Install Oh My Zsh**:

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

3. **Sync configs**:

```bash
rm ~/.zshrc
stow --no-folding .
source ~/.zshrc
```

## 📁 File Structure

```
dotfiles/
├── .zshrc              # zsh configuration
├── aliases.zsh         # aliases
├── install.sh          # installation script
├── lib/
│   └── install.sh      # functions library
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

### Development Tools

| Tool               | Purpose                                      |
| ------------------ | -------------------------------------------- |
| **bin**            | GitHub release downloader and binary manager |
| **task**           | Task runner (Taskfile.yml)                   |
| **kubectl-switch** | Kubernetes context/namespace switcher        |
| **neovim**         | Modern Vim editor                            |
| **lazygit**        | Terminal UI for git                          |
| **lazydocker**     | Terminal UI for Docker                       |
| **uv**             | Fast Python package installer                |
| **jq/yq**          | JSON/YAML processors                         |
| **eza**            | Modern replacement for ls                    |
| **bat**            | Cat clone with syntax highlighting           |
| **fzf**            | Fuzzy finder                                 |
| **ripgrep (rg)**   | Fast grep alternative                        |
| **fd**             | Fast find alternative                        |
| **zoxide**         | Smarter cd command                           |

## 📜 License

This project is open source and available under the [MIT License](LICENSE).

---

**Happy coding!** 🎉
