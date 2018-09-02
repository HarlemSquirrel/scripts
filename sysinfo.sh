#!/bin/bash

kernel_version=`uname -r`
opengl_software_version=`glxinfo 2>&1 | grep "OpenGL version string"`
printf "\nSoftware versions:\n"
printf "  Kernel $kernel_version\n"
printf "  $opengl_software_version\n"

cpu_uname=`uname -m`
cpu_info=`grep "model name" /proc/cpuinfo | head -1 | sed 's/^[^:]*: //'`
cpu_speed=`sudo dmidecode -t processor | grep Speed`
printf "\n\nCPU hardware:\n"
printf "  $cpu_uname\n"
printf "  $cpu_info\n"
printf "  $cpu_speed\n"

printf "\n\nMemory:\n"
sudo dmidecode -t memory | egrep -m 1  'Speed: [0-9]'
free -h

opengl_renderer=`glxinfo 2>&1 | grep "OpenGL renderer string"`
gpu_info=`lspci -d ::0300 -nn`
printf "\n\nGPU hardware:\n"
printf "  $opengl_renderer\n"
printf "  $gpu_info\n"

board_name=`cat /sys/devices/virtual/dmi/id/board_name`
board_vendor=`cat /sys/devices/virtual/dmi/id/board_vendor`
bios_version=`sudo dmidecode -s bios-version`
printf "\n\nMotherboard:\n"
printf "  $board_vendor\n"
printf "  $board_name\n"
printf "  BIOS Version: $bios_version\n"

printf "\n\nStorage:\n"
sudo nvme smart-log /dev/nvme0
