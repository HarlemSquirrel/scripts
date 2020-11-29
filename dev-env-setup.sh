#!/bin/bash

# Exit if any command fails
set -e

if command -v apt-get 2>/dev/null; then
	printf "\n==> Installing dependencies with apt-get...\n"
	sudo apt-get install atom curl git python3-pip vim zsh
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

printf "\nDone! :)\n"
