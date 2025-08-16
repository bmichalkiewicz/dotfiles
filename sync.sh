rm -rf ~/.zshrc

stow .

echo '## Execute `source ~/.zshrc`.' | gum format
