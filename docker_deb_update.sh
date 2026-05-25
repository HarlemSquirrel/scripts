#!/bin/bash

set -e

if [ -f ~/portainer-compose.yaml ]; then
  docker compose -f ~/portainer-compose.yaml down
else
  docker compose down
fi

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

if [ -f ~/portainer-compose.yaml ]; then
  echo "Updating Portainer container..."
  docker compose -f ~/portainer-compose.yaml pull
  docker compose -f ~/portainer-compose.yaml up -d --remove-orphans --force-recreate
else
  echo "Updating containers..."
  # Update containers
  docker compose pull

  # So containers will come up after reboot automatically
  docker compose up -d --remove-orphans --force-recreate
fi

# Reboot
sudo reboot
