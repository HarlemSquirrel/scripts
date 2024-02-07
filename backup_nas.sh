#!/bin/bash

# rsync -r nas:/mnt/BigPool/backups /mnt/Storage250/freenas_backup/
rsync -r nas:/mnt/BigPool/Shared /mnt/Storage250/freenas_backup/
#rsync -r nas:/mnt/BigPool/valheim /mnt/Storage250/freenas_backup/

rsync -r nas:~/Music /mnt/Storage250/
