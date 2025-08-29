# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Architecture

This is a comprehensive dotfiles repository that uses **GNU Stow** for symlink management and **Devbox** for reproducible development environments. The architecture consists of three main layers:

1. **Installation Layer** (`install.sh` + `lib/install.sh`): Modular installation functions for system packages, language runtimes, and development tools
2. **Configuration Layer**: Shell configurations (`.zshrc`, `aliases.zsh`), git settings (`.gitconfig`), and application configs (`confs/`)
3. **Environment Management**: Devbox configuration (`devbox.json`) and Stow ignore rules (`.stow-local-ignore`)

### Key Components

- **`lib/install.sh`**: Contains all installation functions. Each function is self-contained and handles a specific category (Docker, AWS CLI, Python tools, etc.)
- **`aliases.zsh`**: Modern CLI tool aliases that replace traditional commands (ls→eza, cat→bat, vim→nvim)
- **`devbox.json`**: Defines the reproducible development environment with specific tool versions and custom scripts
- **`confs/`**: Application-specific configurations that are NOT managed by Stow (see `.stow-local-ignore`)

## Common Commands

### Primary Workflow Commands
```bash
# Full installation (run once)
./install.sh

# Sync dotfiles after making changes
devbox run sync

# Enter the managed development environment  
devbox shell

# Quick setup (combines installation + sync)
devbox run setup
```

### Development Commands
```bash
# Test a specific installation function
source lib/install.sh && install_rust  # or any other install_* function

# Check what Stow would link
stow --no --verbose .

# Force re-link dotfiles (if conflicts exist)
stow --restow .

# View devbox environment info
devbox info
```

### Configuration Management
```bash
# Edit shell configuration
vim .zshrc          # Main ZSH config
vim aliases.zsh     # Command aliases

# Edit installation logic
vim lib/install.sh  # Add/modify installation functions
vim install.sh      # Modify installation sequence
```

## Architecture Patterns

### Installation Function Pattern
All installation functions in `lib/install.sh` follow this pattern:
- Echo descriptive message with emoji
- Create necessary directories
- Download/install with error handling  
- Clean up temporary files
- No global state dependencies between functions

### Stow Integration
The `.stow-local-ignore` file excludes non-dotfile content from symlinking:
- Infrastructure files (`/.devbox`, `/.git`, `/install.sh`)  
- Configuration templates (`/confs` - these require manual placement)
- This allows the repo root to contain both dotfiles and management scripts

### Devbox Environment Model
- `devbox.json` pins exact tool versions for reproducibility
- Custom scripts (`sync`, `setup`) provide consistent workflows
- Shell integration via `eval "$(devbox global shellenv --init-hook)"` in `.zshrc`
- No package conflicts since Devbox provides isolated environments

### Shell Configuration Layering
1. **Environment setup**: PATH, exports, tool initialization
2. **Framework loading**: Oh My Zsh with selected plugins  
3. **Custom enhancements**: Pure theme, completions, aliases
4. **Tool integrations**: Devbox, Docker, Kubernetes, cloud tools

## Important Implementation Details

### ZSH Plugin Management
The configuration uses Oh My Zsh but supplements it with:
- Manual git clone for `zsh-syntax-highlighting` and `zsh-autosuggestions` 
- Custom completion loading with error checking (`_load_completion` function)
- Lazy-loaded completions to improve shell startup time

### Cross-Platform Considerations  
WezTerm configuration (`confs/wezterm.lua`) detects OS and adjusts:
- Windows: WSL integration, system backdrop effects
- macOS: Alt key behavior modifications
- Linux: Wayland support enablement

### Modern CLI Tool Strategy
Aliases replace traditional tools with modern alternatives that provide:
- Better UX (colors, icons, better defaults)
- Enhanced functionality (git integration in `eza`, syntax highlighting in `bat`)
- Maintained consistency across different environments