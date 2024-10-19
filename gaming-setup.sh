#!/bin/bash

if command -v apt >>/dev/null; then
  printf "\n==> Installing dependencies with apt...\n"

  if ( ! command -v polychromatic-cli >>/dev/null ); then
    # https://polychromatic.app/download/ubuntu/
    sudo add-apt-repository ppa:openrazer/stable
    sudo add-apt-repository ppa:polychromatic/stable
    sudo apt install openrazer-meta polychromatic
  fi

  if ( ! command -v signal-desktop >>/dev/null ); then
    # https://signal.org/download/linux/
    # 1. Install our official public software signing key:
    wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
    cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

    # 2. Add our repository to your list of repositories:
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
    sudo tee /etc/apt/sources.list.d/signal-xenial.list

    # 3. Update your package database and install Signal:
    sudo apt update && sudo apt install signal-desktop
  fi

  if ( ! command -v steam >>/dev/null ); then
    sudo apt install steam-installer
  fi
fi # end apt

printf "\nDone\n"
