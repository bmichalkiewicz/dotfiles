sudo apt-get install -y build-essential procps curl file git unzip zsh

# https://github.com/zdharma-continuum/zinit?tab=readme-ov-file#install
bash -c "$(curl --fail --show-error --silent \
    --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# https://www.kcl-lang.io/docs/user_docs/getting-started/install#linux-1
wget -q https://kcl-lang.io/script/install-kcl-lsp.sh -O - | /bin/bash

# https://www.jetify.com/devbox/docs/installing_devbox/
curl -fsSL https://get.jetify.com/devbox | bash

# https://github.com/zyedidia/eget
bash -c "$(curl --fail --show-error --silent \
    --location https://zyedidia.github.io/eget.sh )"

mkdir -p ~/.local/bin && mv eget ~/.local/bin/

# https://github.com/hidetatz/kubecolor
~/.local/bin/eget hidetatz/kubecolor --to ~/.local/bin

# https://github.com/sharkdp/bat
~/.local/bin/eget sharkdp/bat --asset gnu --to ~/.local/bin
