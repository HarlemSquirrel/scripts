#!/bin/bash

rsync -r freenas:/mnt/BigPool/backups /mnt/Storage250/freenas_backup/
rsync -r freenas:/mnt/BigPool/Shared /mnt/Storage250/freenas_backup/
rsync -r freenas:/mnt/BigPool/valheim /mnt/Storage250/freenas_backup/

rsync -r freenas:~/Music /mnt/Storage250/
