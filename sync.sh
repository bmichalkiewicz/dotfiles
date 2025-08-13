
rm ~/.zshrc

chezmoi init https://github.com/bmichalkiewicz/dotfiles.git
chezmoi apply -v

echo "## Follow the instructions at https://github.com/tonsky/FiraCode/wiki/VS-Code-Instructions to enable Fira Code in VS Code" \
    | gum format

echo '## Execute `source ~/.zshrc`.' | gum format
