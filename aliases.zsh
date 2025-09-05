# ls
EZA_PARAMS=(
	'--icons=always' \
	'--classify' \
	'--group-directories-first' \
	'--time-style=long-iso' \
	'--group' \
	'--color-scale' \
)

alias ls='eza $EZA_PARAMS'
alias la='eza $EZA_PARAMS --all'
alias lg='eza $EZA_PARAMS --git-ignore --all'
alias ll='eza -halF --icons=always'
alias tree='eza --tree $EZA_PARAMS'
alias trea='eza --all --tree $EZA_PARAMS'

# cat
alias cat='bat --paging never --theme DarkNeon --style plain'

# vim
alias vim="nvim.appimage"
alias fim='fzf --multi --bind "enter:become(vim {})"'

# git
alias g='git'
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gc='git commit'
alias gst='git stash'
alias gsp='git stash pop'
alias gch='git checkout'

# kubectl
alias k='kubecolor'
alias kns='kubectl-switch ns'
alias kctx='kubectl-switch ctx'

# sudo
alias please='sudo !!'

# argocd
alias ac="argo-cd"

# lazygit
alias lg="lazygit"
