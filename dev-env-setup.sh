#!/bin/bash

# Exit if any command fails
set -e

if command -v apt-get 2>/dev/null; then
	printf "\n==> Installing dependencies with apt-get...\n"
	sudo apt-get install atom curl git libpq-dev python3-pip vim zsh

	# Docker
    # https://docs.docker.com/engine/install/ubuntu/
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
	sudo apt-get install docker-ce docker-ce-cli containerd.io
fi

# fzf
# https://github.com/junegunn/fzf#using-git
if [ ! -d "$HOME/.fzf" ]; then
  printf "\n==> Getting fzf...\n"
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

# NVM
# https://github.com/nvm-sh/nvm
printf "\n==> Installing/updating NVM...\n"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install node

# Yarn
# https://yarnpkg.com/getting-started/install
npm install -g yarn

# Oh My Zsh
# https://github.com/ohmyzsh/ohmyzsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	printf "\n==> Getting Oh My Zsh...\n"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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
pip install --user --upgrade docker-compose dotfiles speedtest-cli

printf "\n==> Adding user to some groups...\n"
sudo gpasswd --add $USER docker

# Atom
if command -v apm 2>/dev/null; then
  printf "\n==> Installing Atom packages...\n"
  apm install atom-beautify editorconfig \
      language-dotenv language-generic-config language-haml \
       linter-eslint linter-rubocop sort-lines
else
  printf "\n==> Not found: apm. SKIPPING Atom packages...\n"
fi

printf "\nDone! :)\n"
