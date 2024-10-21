#!/bin/sh

if command -v apt-get 2>/dev/null; then
  printf "\n==> Installing dependencies with apt...\n"

  printf "\n==> Installing dependencies with apt-get...\n"
  sudo apt-get install curl dnsutils git imagemagick libmagickwand-dev libpq-dev peek python3-pip vim zsh

  # Postgres
  sudo apt-get install postgresql-15 postgresql-client-15 postgis postgresql-15-postgis-3

  if ( ! command -v add-apt-repository >>/dev/null ); then
    sudo apt install software-properties-common
  fi

  # Docker
  # https://docs.docker.com/engine/install/ubuntu/
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # GitHub CLI
  # https://github.com/cli/cli/blob/trunk/docs/install_linux.md
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update
  sudo apt install gh
elif command -v pacman >>/dev/null; then
  printf "\n==> Installing dependencies with pacman...\n"

  sudo pacman -S android-tools curl docker docker-compose git github-cli peek postgresql-libs python-pip starship ttf-font-nerd vim zsh
fi

# Exit if any command fails
set -e

# fzf
# https://github.com/junegunn/fzf#using-git
if ( ! command -v fzf >>/dev/null ); then
  printf "\n==> Getting fzf...\n"
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

# NVM
# https://github.com/nvm-sh/nvm
if ( ! command -v nvm >>/dev/null ); then
  printf "\n==> Installing/updating NVM...\n"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  nvm install node
fi

# Rust
# https://www.rust-lang.org/learn/get-started
if ( ! command -v cargo >>/dev/null ); then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Yarn
# https://yarnpkg.com/getting-started/install
npm install -g yarn

# Oh My Zsh
# https://github.com/ohmyzsh/ohmyzsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	printf "\n==> Getting Oh My Zsh...\n"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Starship
# https://starship.rs/
if ( ! command -v starship > /dev/null ); then
  printf "\n==> Getting Starship...\n"
  curl -sS https://starship.rs/install.sh | sh
fi


# RVM
# https://rvm.io/
if [ ! -d "$HOME/.rvm" ]; then
	printf "\n==> Getting RVM...\n"
	gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
	curl -sSL https://get.rvm.io | bash -s stable
fi

# vim-plug
# https://github.com/junegunn/vim-plug
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
	printf "\n==> Getting vim-plug...o\n"
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Python packages
pip install --user --upgrade dotfiles bpytop speedtest-cli
if ! command -v docker-compose >>/dev/null; then
  pip install --user --upgrade docker-compose
fi

printf "\n==> Adding user to some groups...\n"
sudo gpasswd --add $USER docker

printf "\nDone! :)\n"
