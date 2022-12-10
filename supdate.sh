#!/bin/bash

if command -v apt >/dev/null 2>&1; then
  sudo apt update -qq && sudo apt full-upgrade
fi

if command -v pacman >/dev/null 2>&1; then
  sudo pacman -Syu
fi

if command -v flatpak >/dev/null 2>&1; then
  flatpak update
fi

if command -v snap >/dev/null 2>&1; then
  sudo snap refresh
fi

if [[ -f /var/run/reboot-required ]]; then
  printf "\n  🔄 Reboot required.\n\n"
fi
