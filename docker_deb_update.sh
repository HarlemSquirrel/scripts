#!/bin/bash

set -e

docker compose down

# Backup
if [ -d frigate ]; then
  zip -r "frigate_$(date +'%Y%m%d.%H%M').zip" frigate
  rsync -a backups/* nas:/mnt/BigPool/backups/frigate/
fi

# Cleanup
docker system prune -f

# Update system
sudo apt-get update
sudo apt-get dist-upgrade -y

# Update containers
docker compose pull

# Do containers will come up after reboot automatically
docker compose up -d --remove-orphans --force-recreate

# Reboot
sudo reboot
