#!/bin/bash

printf "  --Before--\n"
df -h --total

printf "\nWe are now going to clean some shit up...\n"

# echo "Cleaning up old files in /var..."
# sudo find /var/* -atime +30 | wc -l
# sudo find /var/* -atime +30 -delete

if command -v apt >/dev/null 2>&1; then
  printf "Running apt autoremove and autoclean...\n"
  sudo apt -y autoremove
  sudo apt -y autoclean
  sudo apt -y clean
  printf "Removing residual config files...\n"
  sudo dpkg --purge $(dpkg --get-selections | grep deinstall | cut -f1)
elif command -v pacman >/dev/null 2>&1; then
  printf "Cleaning up Pacman cache...\n"
  sudo paccache -r
  sudo paccache -ruk0
fi

# printf "Cleaning up config, cache, and share files in the home directory...\n"
# find ~/.config/* -atime +90 | wc -l
# find ~/.config/* -atime +90 -delete
# find ~/.cache/* -atime +90 | wc -l
# find ~/.cache/* -atime +90 -delete
# find ~/.local/share/* -atime +90 | wc -l
# find ~/.local/share/* -atime +90 -delete

printf "Removing broken symlinks...\n"
find ~/. -type l -! -exec test -e {} \; -print | wc -l
find ~/. -type l -! -exec test -e {} \; -delete

printf "Removing all but the last 30 days of journal logs...\n"
sudo journalctl --vacuum-time=30d

printf "Taking out the trash...\n"
trash-empty

printf "--After--\n"
df -h --total

printf "\nAll done here!\n"
