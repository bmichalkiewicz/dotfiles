# Load zsh completion system
autoload -Uz compinit && compinit

# Oh My Zsh and paths
export ZSH="$HOME/.oh-my-zsh"
export PATH="/usr/local/bin:$HOME/.local/bin:$PATH"
export GOPATH="$HOME/go/packages"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

plugins=(
  git
  sudo
  helm
  kubectx
  kubectl
  fzf
  colored-man-pages
  colorize
  cp
  zsh-syntax-highlighting
  zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

# History
setopt HIST_IGNORE_ALL_DUPS

# Aliases
source "$HOME/aliases.zsh"

# Prompt (Pure)
fpath+=($HOME/.zsh/pure)
autoload -U promptinit && promptinit
prompt pure

# Devbox
export DEVBOX_NO_PROMPT=true
eval "$(devbox global shellenv --init-hook)"

# CLI completions
source <(devbox completion zsh)
source <(docker completion zsh)
source <(kubectl completion zsh)
source <(kubectl-switch completion zsh)

# Extra tools
eval $(thefuck --alias)                      # The Fuck
eval "$(zoxide init --cmd cd zsh)"           # Zoxide
compdef kubecolor=kubectl                    # Kubecolor
export KUBECONFIG_DIR="$HOME/.kube/config.d" # Kubectl-switch

