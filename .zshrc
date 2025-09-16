# Environment Variables
export ZSH="$HOME/.oh-my-zsh"
export VOLTA_HOME="$HOME/.volta"
export GIT_PATH="$HOME/git"
export GOPATH="$HOME/go/packages"
export KUBECONFIG_DIR="$HOME/.kube/config.d"

# Path Configuration
path=(
  $VOLTA_HOME/bin
  /usr/local/bin
  $HOME/.local/bin
  /usr/local/go/bin
  $GOPATH/bin
  $path
)
export PATH

# Load zsh completion system
autoload -Uz compinit && compinit

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
  colored-man-pages
)
source $ZSH/oh-my-zsh.sh

# History Configuration
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
HISTSIZE=10000
SAVEHIST=10000

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

# Lazy load completions function
_load_completion() {
  local cmd="$1"
  local comp_cmd="$2"
  if command -v "$cmd" &> /dev/null; then
    source <(eval "$comp_cmd")
  fi
}

# CLI completions with error checking
_load_completion devbox "devbox completion zsh"
_load_completion docker "docker completion zsh"
_load_completion kubectl "kubectl completion zsh"
_load_completion kubectl-switch "kubectl-switch completion zsh"
_load_completion k9s "k9s completion zsh"

# Autosuggest settings
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Extra tools with error checking
command -v zoxide &> /dev/null && eval "$(zoxide init --cmd cd zsh)"
command -v kubecolor &> /dev/null && compdef kubecolor=kubectl

# Superfile with directory tracking
if command -v spf &> /dev/null; then
  spf() {
    local spf_last_dir
    case "$(uname -s)" in
      Linux)  spf_last_dir="${XDG_STATE_HOME:-$HOME/.local/state}/superfile/lastdir" ;;
      Darwin) spf_last_dir="$HOME/Library/Application Support/superfile/lastdir" ;;
      *) command spf "$@"; return ;;
    esac

    command spf "$@"

    [[ -f "$spf_last_dir" ]] && {
      . "$spf_last_dir"
      rm -f "$spf_last_dir" 2>/dev/null
    }
  }
fi
