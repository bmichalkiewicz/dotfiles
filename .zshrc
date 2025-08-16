autoload -Uz compinit
compinit

setopt HIST_IGNORE_ALL_DUPS

source "$HOME/aliases.zsh"

export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Devbox
DEVBOX_NO_PROMPT=true
eval "$(devbox global shellenv --init-hook)"

# Completions
source <(devbox completion zsh)
source <(docker completion zsh)
source <(kubectl completion zsh)
source <(kubectl-switch completion zsh)

# Starship
eval "$(starship init zsh)"

# The Fuck
eval $(thefuck --alias)

# Zoxide
eval "$(zoxide init --cmd cd zsh)"

# fzf
source <(fzf --zsh)

# kubecolor
compdef kubecolor=kubectl

# Go
export GOPATH="$HOME/go/packages"
export PATH=$PATH:/usr/local/go/bin
export PATH="$HOME/go/bin:$PATH"

# kubectl-switch
export KUBECONFIG_DIR="$HOME/.kube/config.d"

# Plugins
PLUGIN_DIR="$HOME/.local/share/zsh/plugins"

# Auto-suggestions
ZSH_AUTOSUGGEST_STRATEGY=( history completion )

if [[ ! -e "$PLUGIN_DIR/zsh-autosuggestions" ]]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$PLUGIN_DIR/zsh-autosuggestions"
fi
source "$PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"

# Syntax Highlighting
if [[ ! -e "$PLUGIN_DIR/zsh-syntax-highlighting" ]]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGIN_DIR/zsh-syntax-highlighting"
fi
source "$PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
