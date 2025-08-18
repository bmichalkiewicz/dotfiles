# 1. Install Oh My Zsh
```bash
sudo apt update
sudo apt install -y curl wget git zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

# 2. Clone this repo
```bash
cd ~
git clone https://github.com/bmichalkiewicz/dotfiles
cd ~/dotfiles
```

# 3. Run setup scripts
```bash
chmod +x ./install.sh && ./install.sh
devbox shell
./sync.sh
```
