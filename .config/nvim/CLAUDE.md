# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Neovim Configuration Architecture

This is a personal Neovim configuration based extensively on [echasnovski's mini.nvim ecosystem](https://github.com/echasnovski/nvim). The configuration is structured using mini.deps for plugin management and follows a modular approach.

### Core Structure

- **init.lua**: Bootstrap mini.nvim and set up mini.deps
- **plugin/**: Core configuration files loaded in numbered order:
  - `10_options.lua`: Global editor settings and options
  - `11_mappings.lua`: Key mappings and leader key definitions  
  - `12_functions.lua`: Custom utility functions and Config namespace
  - `20_mini.lua`: Mini.nvim plugin configurations
  - `21_plugins.lua`: Non-mini plugins and colorschemes
- **lsp/**: Language server specific configurations
- **after/ftplugin/**: Filetype-specific settings
- **colors/**: Custom colorschemes (minihues variants)
- **snippets/**: JSON snippet files for mini.snippets

### Key Architecture Patterns

The configuration uses a global `Config` table (`_G.Config`) to organize custom functions and utilities. This pattern allows accessing custom functionality from anywhere in the configuration.

The setup follows mini.deps patterns with `now()` for immediate loading and `later()` for deferred loading to optimize startup time.

### Plugin Management

All plugins are managed via mini.deps. The configuration includes:
- Complete mini.nvim ecosystem integration
- LSP configuration using built-in neovim LSP client
- Completion via blink.cmp
- Tree-sitter for syntax highlighting
- Two carefully selected colorschemes with custom highlight overrides

### Development Workflow

**Installing/Updating Plugins:**
```bash
# Update all dependencies
:DepsUpdate

# Clean unused dependencies  
:DepsClean

# Save current plugin snapshot
:DepsSnapSave

# Load a plugin snapshot
:DepsSnapLoad
```

**LSP Management:**
```bash
# Install language servers
:Mason

# Check LSP status
:LspInfo
```

**Key Development Commands:**
- `<leader>ff`: Open file explorer (mini.files)
- `<leader>fg`: Find git files  
- `<leader>gg`: Toggle lazygit
- `<leader>ca`: Code actions
- `<leader>cr`: Rename symbol

### Language Server Setup

Language servers are configured via individual files in the `lsp/` directory and enabled through `vim.lsp.enable()`. Supported languages include:
- Lua (lua_ls with workspace configuration)
- Go (gopls with inlay hints)  
- Python (basedpyright + ruff)
- Rust (rust_analyzer)
- JSON, YAML, Markdown

### Custom Features

- **Session management**: Save/load sessions with mini.sessions
- **Git integration**: Mini.git + lazygit integration  
- **Code formatting**: Conform.nvim with format-on-save toggle
- **Minimap**: Auto-enabled for specific filetypes (Go, Lua, Python, etc.)
- **Contextual search**: Aligned grep results with keyword highlighting

### Colorscheme Configuration

Two colorschemes are configured with extensive highlight overrides:
- **gruvbox** (currently active): A retro groove color scheme with warm earth tones
- **catppuccin**: Popular pastel theme with mocha and macchiato variants

Both colorschemes include custom highlights for mini.nvim components and consistent TODO/FIXME/HACK/NOTE highlighting.

### Key Concepts

- Uses `jk` for escape in insert mode
- Space as leader key with organized leader groups
- Leap motion for navigation (`m` key)
- Auto-format toggle with `\f`
- Persistent undo and session restore