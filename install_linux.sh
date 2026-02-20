#!/bin/bash
# Linux Mint / Ubuntu Neovim & Dev Environment Setup
set -e 

echo "🚀 Starting Linux development environment setup..."

# 1. Update system and install base requirements
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release git zsh ripgrep fd-find nodejs golang-go rustc python3 python3-pip

# 2. Set up Docker's Official Repository
echo "🐳 Setting up Docker..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes

# Note: Mint is based on Ubuntu. This command detects the base Ubuntu version for the repo.
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 3. Docker Post-Install (Allows running docker without sudo)
sudo usermod -aG docker $USER
echo "✅ Docker installed. (Note: You'll need to reboot or relog for sudo-less docker to work)"

# 4. Install/Update Neovim
# Adding the Unstable PPA to ensure you have 0.9+ for modern dotfiles
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y neovim

# 5. Handle Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "📦 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 6. Create Symlinks
echo "🔗 Creating symlinks for dotfiles..."
mkdir -p "$HOME/.config"

# Neovim
if [ -d "$HOME/.config/nvim" ]; then
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%Y%m%d)"
fi
ln -sf "$HOME/dotfiles/nvim" "$HOME/.config/nvim"

# Zshrc & Aliases
ln -sf "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
ln -sf "$HOME/dotfiles/.aliases" "$HOME/.aliases"

echo ""
echo "🎉 Setup complete!"
echo "-------------------------------------------------------"
echo "Next steps:"
echo "1. Run: chsh -s $(which zsh)"
echo "2. REBOOT your computer (required for Docker permissions)."
echo "3. Open a terminal and run 'nvim' to trigger plugin installs."
echo "-------------------------------------------------------"
