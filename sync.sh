
rm ~/.zshrc

chezmoi init bmichalkiewicz/dotfiles
chezmoi apply -v

echo "## Follow the instructions at https://github.com/tonsky/FiraCode/wiki/VS-Code-Instructions to enable Fira Code in VS Code" \
    | gum format

# https://github.com/hidetatz/kubecolor
sudo eget hidetatz/kubecolor

# https://github.com/sharkdp/bat
sudo eget sharkdp/bat --asset gnu

echo '## Execute `source ~/.zshrc`.' | gum format
