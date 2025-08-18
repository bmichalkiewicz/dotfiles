autoload -Uz compinit
compinit

# Oh My Zsh path
export ZSH="$HOME/.oh-my-zsh"

plugins=(
  helm
  kubectx
  kubectl
  git
  sudo
  colored-man-pages
  colorize
  cp
  fzf
  zsh-syntax-highlighting
  zsh-autosuggestions
)

setopt HIST_IGNORE_ALL_DUPS

source "$HOME/aliases.zsh"

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Prompt
autoload -U promptinit; promptinit
fpath+=($HOME/.zsh/pure)
prompt pure

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

# kubecolor
compdef kubecolor=kubectl

# Go
export GOPATH="$HOME/go/packages"
export PATH=$PATH:/usr/local/go/bin
export PATH="$HOME/go/packages/bin:$PATH"

# kubectl-switch
export KUBECONFIG_DIR="$HOME/.kube/config.d"
