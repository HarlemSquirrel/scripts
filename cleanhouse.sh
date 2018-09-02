#!/bin/bash

echo "We are now going to clean some shit up..."
# sleep 2

# echo "Cleaning up old files in /var..."
# sudo find /var/* -atime +30 | wc -l
# sudo find /var/* -atime +30 -delete

echo "Cleaning up pacman cache..."
sudo paccache -r
sudo paccache -ruk0

# echo "Cleaning up config, cache, and share files in the home directory..."
# find ~/.config/* -atime +90 | wc -l
# find ~/.config/* -atime +90 -delete
# find ~/.cache/* -atime +90 | wc -l
# find ~/.cache/* -atime +90 -delete
# find ~/.local/share/* -atime +90 | wc -l
# find ~/.local/share/* -atime +90 -delete

echo "Removing broken symlinks..."
find ~/. -type l -! -exec test -e {} \; -print | wc -l
find ~/. -type l -! -exec test -e {} \; -delete

echo "Removing all but the last 30 days of journal logs..."
sudo journalctl --vacuum-time=30d

echo "All done here!"
# sleep 2
