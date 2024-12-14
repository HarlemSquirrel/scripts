#!/bin/bash

##
# Update system across multiple package managers
#

printf "\n  🚀 Initializing system update...\n"

if command -v apt >/dev/null 2>&1; then
  printf "\n  🍕 apt\n"
  sudo apt update && sudo apt full-upgrade

  if [[ -f ~/code/scripts/update_zoom.sh ]]; then
  printf "\n  update_zoom.sh\n"
    ~/code/scripts/update_zoom.sh
  fi
fi

if command -v brew >/dev/null 2>&1; then
  printf "\n  🍺 brew\n"
  brew update
  brew upgrade
fi

if command -v paru >/dev/null 2>&1; then
  printf "\n  👾 paru\n"
  paru -Syu
elif command -v pacman >/dev/null 2>&1; then
  printf "\n  👾 pacman\n"
  sudo pacman -Syu
fi


if command -v flatpak >/dev/null 2>&1; then
  printf "\n  📦 flatpak\n"
  flatpak update
fi

if command -v snap >/dev/null 2>&1; then
  printf "\n  ❇️  snap\n"
  sudo snap refresh
fi

if [[ -f /var/run/reboot-required ]]; then
  printf "\n  🔄 Reboot required.\n\n"
fi
