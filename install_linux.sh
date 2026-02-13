#!/bin/bash
# Linux Mint / Ubuntu Neovim Setup
set -e 

echo "🚀 Starting Linux Neovim setup..."

# 1. Update system
sudo apt update

# 2. Install dependencies via APT
echo "📦 Installing Neovim, Ripgrep, and languages..."
sudo apt install -y neovim ripgrep fd-find nodejs golang-go rustc python3 python3-pip zsh curl git

# 3. Handle Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "📦 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 4. Create Symlinks (Same logic as your macOS script)
mkdir -p "$HOME/.config"

# Neovim Symlink
if [ -d "$HOME/.config/nvim" ]; then
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%Y%m%d)"
fi
ln -sf "$HOME/dotfiles/nvim" "$HOME/.config/nvim"

# Zshrc & Aliases
ln -sf "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
ln -sf "$HOME/dotfiles/.aliases" "$HOME/.aliases"

echo "✅ Setup complete! Run 'chsh -s $(which zsh)' to make Zsh your default shell."
