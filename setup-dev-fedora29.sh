#!/bin/bash

# Development environment setup on Fedora 29

# Remove old Docker versions
sudo dnf remove docker \
				 docker-client \
         docker-client-latest \
				 docker-common \
				 docker-latest \
				 docker-latest-logrotate \
				 docker-logrotate \
			   docker-selinux \
				 docker-engine-selinux \
				 docker-engine

# Install commands to manage DNF repositories from the command line
sudo dnf install dnf-plugins-core

# Add Docker repo
# https://docs.docker.com/install/linux/docker-ce/fedora/#set-up-the-repository
# https://github.com/docker/for-linux/issues/430
sudo dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo

# Install packages
sudo dnf install ansible chromium curl docker-ce git gnome-tweaks openldap-clients \
                 util-linux-user vim xdotool zsh zsh-syntax-highlighting

# Install Docker Compose
# https://docs.docker.com/compose/install/#install-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add user to docker group
sudo usermod -aG docker $(whoami)

# Install Slack from Flathub
# https://flathub.org/apps/details/com.slack.Slack
flatpak install flathub com.slack.Slack

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Atom
printf "\nDownloading and installing Atom...\n"
atom_link=$(curl -s https://api.github.com/repos/atom/atom/releases/latest | grep "browser_download_url.*rpm" | cut -d '"' -f 4)
wget --directory-prefix="$HOME/Downloads" --timestamping "$atom_link"
sudo dnf install ~/Downloads/atom.x86_64.rpm

# RVM
# https://rvm.io/
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s master

# Yarn
# https://yarnpkg.com/en/docs/install#centos-stable
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo dnf install yarn

# Zoom
# https://zoom.us/download#client_4meeting
wget --directory-prefix=~/Downloads --timestamping \
	"https://zoom.us/client/latest/zoom_x86_64.rpm"
sudo dnf install ~/Downloads/zoom_x86_64.rpm


printf "\nDone! :)\n"
