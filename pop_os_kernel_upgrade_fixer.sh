#!/bin/bash

## Fixup failed kernel upgrade
# https://github.com/pop-os/pop/issues/3840
#


# Need to run this as root.
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Exit early on error
set -e

# Show boot partition usage
df -h /boot/efi

read -p "Ready to remove previous EFI artifacts? (y/N) " ans

if [ "$ans" != "y" ];
  then exit 0
fi

# Remove previous
rm /boot/efi/EFI/Pop_OS-*/initrd.img-previous /boot/efi/EFI/Pop_OS-*/vmlinuz-previous.efi

df -h /boot/efi

dpkg --configure -a
