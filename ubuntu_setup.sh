#!/bin/bash

# Oracle Java
# http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html
# sudo add-apt-repository ppa:webupd8team/java

# Install packages
pkgs=(apache2-utils ansible build-essential chromium-bowser curl docker docker-compose
      gir1.2-gtop-2.0 gir1.2-networkmanager-1.0 git gnome-nettool gufw lm-sensors
      network-manager-openconnect-gnome network-manager-vpnc-gnome
      openjdk-8-jdk vim xclip xdotool yarn)
media_pkgs=(libavcodec-extra)
capybara_webkit_pkgs=(qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x)
ldap_pkgs=(slapd ldap-utils)
power_pkgs=(linux-tools-generic tlp tlp-rdw)
zsh_pkgs=(zsh zsh-syntax-highlighting)

# yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update
sudo apt-get install ${pkgs[*]} ${capybara_webkit_pkgs[*]} ${ldap_pkgs[*]} ${media_pkgs[*]} ${zsh_pkgs[*]}

# Power management and savings
sudo apt-get install ${power_pkgs[*]}

# oh-my-zsh
# sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# RVM
#gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
#\curl -sSL https://get.rvm.io | bash -s stable

# GTK Themes
#git clone https://github.com/tliron/install-gnome-themes ~/install-gnome-themes
#~/install-gnome-themes/install-gnome-themes

# Add user to docker group
sudo usermod -aG docker $(whoami)
