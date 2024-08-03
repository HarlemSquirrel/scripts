#!/bin/bash

set -e

adb backup -all -f ~/backups/$(date +%Y%m%d_%H%M)_sting_z9.ab

rsync -a ~/backups nas:/mnt/BigPool/home/hs/
