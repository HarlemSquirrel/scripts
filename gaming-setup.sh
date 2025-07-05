#!/bin/bash

if command -v apt >>/dev/null; then
  printf "\n==> Installing dependencies with apt...\n"

  if ( ! command -v add-apt-repository >>/dev/null ); then
    sudo apt install software-properties-common
  fi

  if ( ! command -v polychromatic-cli >>/dev/null ); then
    # https://polychromatic.app/download/ubuntu/
    sudo add-apt-repository ppa:openrazer/stable
    sudo add-apt-repository ppa:polychromatic/stable
    sudo apt install openrazer-meta polychromatic
  fi

  if ( ! command -v ail-cli >>/dev/null); then
    # https://github.com/TheAssassin/AppImageLauncher
    sudo add-apt-repository ppa:appimagelauncher-team/stable
    sudo apt install appimagelauncher
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
elif command -v pacman >>/dev/null; then
  sudo pacman -S fastfetch lutris signal-desktop steam openrgb gamescope gamemode lib32-gamemode lib32-vkd3d umu-launcher linux-headers

  sudo gpasswd -a $USER gamemode
  sudo gpasswd -a $USER plugdev
  sudo gpasswd -a $USER i2c

  # https://aur.archlinux.org/packages/paru
  paru -S polychromatic

  # https://wiki.archlinux.org/title/Gaming#Increase_vm.max_map_count
  grep "vm.max_map_count" /etc/sysctl.d/80-gamecompatibility.conf || echo "vm.max_map_count = 2147483642" | sudo tee /etc/sysctl.d/80-gamecompatibility.conf

  # Apply the changes without reboot
  sudo sysctl --system
fi


printf "\nDone\n"
