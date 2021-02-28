#!/bin/bash

##
# Create a zip file with a backup of all local data from Valheim including
# characters and worlds.
#

zip -r ~/valheim-world-backup-$(date +%Y%m%d_%H%M).zip ~/.config/unity3d/IronGate/Valheim/
