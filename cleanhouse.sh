#!/bin/bash

# Load helper functions
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
source $SCRIPTPATH/helper_functions.sh

OS="$(uname -s)"

show_disk_usage() {
  if [ "$OS" = "Darwin" ]; then
    # BSD df has no --total flag
    df -h
  else
    df -h --total
  fi
}

# Show disk usage before
colorprintf blue "\n  --Before--\n"
show_disk_usage

printf "\nWe are now going to clean some shit up...\n"

# echo "Cleaning up old files in /var..."
# sudo find /var/* -atime +30 | wc -l
# sudo find /var/* -atime +30 -delete

if command -v brew >/dev/null 2>&1; then
  colorprintf orange "\nRunning brew cleanup...\n"
  brew cleanup
fi

if command -v mise >/dev/null 2>&1; then
  colorprintf orange "\nRunning mise prune...\n"
  mise prune -y
fi

if command -v nvm >/dev/null 2>&1; then
  colorprintf orange "\nRunning nvm cache clear...\n"
  nvm cache clear
fi

if command -v rvm >/dev/null 2>&1; then
  colorprintf orange "\nRunning rvm cleanup all...\n"
  rvm cleanup all
fi

if command -v yarn >/dev/null 2>&1; then
  colorprintf orange "\nRunning yarn cache clean...\n"
  yarn cache clean
fi

if command -v apt >/dev/null 2>&1; then
  colorprintf orange "\nRunning apt autoremove and autoclean...\n"
  sudo apt -y autoremove
  sudo apt -y autoclean
  sudo apt -y clean
  colorprintf orange "\nRemoving residual config files...\n"
  sudo dpkg --purge $(dpkg --get-selections | grep deinstall | cut -f1)
elif command -v pacman >/dev/null 2>&1; then
  colorprintf orange "\nCleaning up Pacman cache...\n"
  sudo paccache -r
  sudo paccache -ru
  if [ -d $HOME/.cache/pikaur/pkg ]; then
    paccache -rk2 --cachedir=$HOME/.cache/pikaur/pkg
    paccache -ruk2 --cachedir=$HOME/.cache/pikaur/pkg
  fi
fi

if command -v flatpak >/dev/null 2>&1; then
  colorprintf orange "\nRemoving unused flatpak packages...\n"
  flatpak uninstall --unused -y
fi
# printf "Cleaning up config, cache, and share files in the home directory...\n"
# find ~/.config/* -atime +90 | wc -l
# find ~/.config/* -atime +90 -delete
# find ~/.cache/* -atime +90 | wc -l
# find ~/.cache/* -atime +90 -delete
# find ~/.local/share/* -atime +90 | wc -l
# find ~/.local/share/* -atime +90 -delete

if command -v docker &>/dev/null; then
  colorprintf orange "\nRunning docker prune....\n"
  docker system prune
fi

# colorprintf orange "\nRemoving broken symlinks...\n"
# find ~/. -type l ! -exec test -e {} \; -print | wc -l
# find ~/. -type l ! -exec test -e {} \; -delete

if command -v journalctl >/dev/null 2>&1; then
  colorprintf orange "\nRemoving all but the last 30 days of journal logs...\n"
  sudo journalctl --vacuum-time=30d
fi

colorprintf orange "\nTaking out the trash...\n"
if [ "$OS" = "Darwin" ]; then
  # Empty the macOS Trash (all volumes) via Finder; skips silently if already empty
  osascript -e 'tell application "Finder" to if (count of items of trash) > 0 then empty trash'
elif command -v trash-empty >/dev/null 2>&1; then
  trash-empty
fi

# Show disk usage after
colorprintf blue "\n  --After--\n"
show_disk_usage

colorprintf green "\nAll done here!\n"
