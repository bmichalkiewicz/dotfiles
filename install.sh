sudo apt-get install -y build-essential procps curl file git unzip

# https://github.com/ohmyzsh/ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# https://github.com/zdharma-continuum/zinit?tab=readme-ov-file#install
bash -c "$(curl --fail --show-error --silent \
    --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# https://www.kcl-lang.io/docs/user_docs/getting-started/install#homebrew-macos-1
brew install kcl-lang/tap/kcl-lsp

# https://www.jetify.com/devbox/docs/installing_devbox/
curl -fsSL https://get.jetify.com/devbox | bash

# https://github.com/hidetatz/kubecolor
brew install kubecolor

# https://github.com/sharkdp/bat
brew install bat
