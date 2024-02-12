#!/usr/bin/env bash
# This script will download and install the Zoom client for Ubuntu

set -e

ZOOM_DEB='zoom_amd64.deb'

version_installed=$(cat /opt/zoom/version.txt)
version_available=$(curl -s https://zoom.us/rest/download\?os\=linux | jq '.result.downloadVO.zoom.version' | grep -oP '[\d.]+')

echo "Installed: ${version_installed}"
echo "Available: ${version_available}"

if [[ "${version_installed}" == "${version_available}" ]]; then
  echo "The latest version of Zoom is already installed."
else
  curl -s -J -L -o /tmp/${ZOOM_DEB} https://zoom.us/client/$version_available/$ZOOM_DEB

  sudo dpkg --install /tmp/${ZOOM_DEB}
  sudo apt install -f
fi
