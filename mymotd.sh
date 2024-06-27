#!/bin/bash

# /etc/profile.d/mymotd.sh

date

# https://github.com/fastfetch-cli/fastfetch
fastfetch --cpu-temp --gpu-temp

printf "\n\n"
docker stats --no-stream

printf "\n\n"

apt list --upgradable -qq
