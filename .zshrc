# Load zsh completion system
autoload -Uz compinit && compinit

# Oh My Zsh and paths
export ZSH="$HOME/.oh-my-zsh"
export PATH="/usr/local/bin:$HOME/.local/bin:$PATH"
export GIT_PATH="$HOME/git"
# Golang
export GOPATH="$HOME/go/packages"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

plugins=(
  git
  sudo
  helm
  kubectx
  kubectl
  fzf
  colorize
  cp
  zsh-syntax-highlighting
  zsh-autosuggestions
  aws
)
source $ZSH/oh-my-zsh.sh

# History
setopt HIST_IGNORE_ALL_DUPS

# Aliases
source "$HOME/aliases.zsh"

# Prompt (Pure)
fpath+=($HOME/.zsh/pure)

# Gita completion
if [[ -d "$HOME/.zsh/completions/gita" ]]; then
  fpath+=($HOME/.zsh/completions/gita)
fi

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
source <(k9s completion zsh)

# Autosuggest settings
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Extra tools
eval "$(zoxide init --cmd cd zsh)"                          # Zoxide
export KUBECONFIG_DIR="$HOME/.kube/config.d"                # Kubectl-switch
compdef kubecolor=kubectl                                   # Kubecolor

# spf
spf() {
  os=$(uname -s)

  # Linux
  if [[ "$os" == "Linux" ]]; then
      export SPF_LAST_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/superfile/lastdir"
  fi

  # macOS
  if [[ "$os" == "Darwin" ]]; then
      export SPF_LAST_DIR="$HOME/Library/Application Support/superfile/lastdir"
  fi

  command spf "$@"

  [ ! -f "$SPF_LAST_DIR" ] || {
      . "$SPF_LAST_DIR"
      rm -f -- "$SPF_LAST_DIR" > /dev/null
  }
}
