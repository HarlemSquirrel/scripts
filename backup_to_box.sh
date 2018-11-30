#!/usr/bin/env bash
## Remote backup script. Requires duplicity and Box account with WebDAV enabled
## Resources:
## http://duplicity.nongnu.org/docs.html
## https://wiki.archlinux.org/index.php/Duplicity#Example_backup_script
## https://help.ubuntu.com/community/DuplicityBackupHowto

CERT_NAME="cacert.pem"
MOZILLA_CA_CERT_STORE="https://curl.haxx.se/ca/cacert.pem"
WORK_DIR="$HOME/.duplicity"

if [ ! -d $WORK_DIR ]; then
  printf "Creating missing directory at $WORK_DIR\n"
  mkdir $WORK_DIR
fi

cd $WORK_DIR

# Make sure we can verify the SSL cert on the remote server
# using the Mozilla CA certificate store
curl --remote-name --silent --time-cond $CERT_NAME -o $CERT_NAME $MOZILLA_CA_CERT_STORE

# We use Python Keyring Lib to store the password for WebDAV
# https://pypi.python.org/pypi/keyring
# pip install keyring
# python -m keyring set Login boxwebdav
export FTP_PASSWORD="$(python -m keyring get Login boxwebdav)"

# Prompt for GPG key passphrase
printf "Enter decryption passphrase: "
read -s password
export PASSPHRASE=$password

enc_key=B4397A5E # Public GPG key
dest="webdavs://hostname@dav.box.com/dav/backup_folder"
src="$HOME"

date
printf "Starting backup...\n"

duplicity --encrypt-key $enc_key \
          --gpg-options "--pinentry-mode=loopback" \
          --full-if-older-than 60D \
          --num-retries 3 \
          --asynchronous-upload \
          --archive-dir="${HOME}/.cache/duplicity" \
          --log-file "${HOME}/.cache/duplicity/duplicity.log" \
          --exclude="${src}/.cache" \
          --exclude="${src}/.local/share/Trash" \
          --exclude="${HOME}/.thumbnails" \
          --exclude="${HOME}/.Private" \
          --exclude="${HOME}/.PlayOnLinux" \
          --exclude="${HOME}/.wine" \
          --exclude="${HOME}/Downloads" \
          --exclude="${HOME}/Music" \
          --exclude="${HOME}/VirtualBox VMs" \
          --ssl-cacert-file "$CERT_DIR/$CERT_NAME" \
          "$src" "$dest"

unset PASSPHRASE
unset FTP_PASSWORD
