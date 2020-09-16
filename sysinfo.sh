#!/bin/bash

board_name=`cat /sys/devices/virtual/dmi/id/board_name`
board_vendor=`cat /sys/devices/virtual/dmi/id/board_vendor`
board_version=`cat /sys/devices/virtual/dmi/id/board_version`
bios_version=`cat /sys/devices/virtual/dmi/id/bios_version`
bios_date=`cat /sys/devices/virtual/dmi/id/bios_date`
printf "\n**Motherboard:\n"
printf "  Board Vendor:  $board_vendor\n"
printf "  Board Name:    $board_name\n"
printf "  Board Version: $board_version\n"
printf "  BIOS Date:     $bios_date\n"
printf "  BIOS Version:  $bios_version\n"

cpu_info=`grep "model name" /proc/cpuinfo | head -1 | sed 's/^[^:]*: //'`
cpu_speed_min=`lscpu | grep -o -P '(?<=CPU min MHz:).+' | grep -o -P '(\d|\.)+'`
cpu_speed_max=`lscpu | grep -o -P '(?<=CPU max MHz:).+' | grep -o -P '(\d|\.)+'`
printf "\n\n**CPU hardware:\n"
printf "  $cpu_info\n"
printf "  Configured Clock Speeds: $cpu_speed_min - $cpu_speed_max MHz\n"

if [[ $EUID > 0 ]]; then
  printf "(Run as root to see CPU boost speed)\n"
else
  cpu_max_boost_speed=`dmidecode -t processor | grep -o -P '(?<=Max Speed: ).+'`
  printf "  Configured Max Speed: $cpu_max_boost_speed\n"
fi

printf "\n\n**System Memory:\n"
if [[ $EUID > 0 ]]; then
  printf "(Run as root to see more memory info)\n"
else
  dmidecode -t memory | grep -P '(Memory Device|\tBank Locator: \w+|\tSpeed: \d+|\tSize: \d+|Configured Voltage: [0-9]|Part Number:|\tManufacturer:)'
fi

gpu_name=`lspci -v -s $(lspci -v | grep VGA | cut -d ' ' -f 1) | grep -oP "(?<=\tSubsystem: ).+"`
gpu_memory_total="$(($(cat /sys/class/drm/card0/device/mem_info_vram_total) / 2**20))"
gpu_power_cap="$(($(find /sys/class/drm/card0/device/ -name power1_cap -exec cat {} \;)  /
1000000))"
gpu_vbios_version=`cat /sys/class/drm/card0/device/vbios_version`
printf "\n\n**GPU hardware:\n"
printf "  $gpu_name\n"
printf "  vBios Version: $gpu_vbios_version\n"
printf "  Memory Total: $gpu_memory_total\n"
printf "  Power Max: $gpu_power_cap Watts\n"

printf "\n\n**Storage:\n"
if [[ $EUID > 0 ]]; then
  printf "(Run as root to see NVME storage info)\n"
else
  nvme smart-log /dev/nvme0
fi

kernel_version=`uname -r`
opengl_renderer=`glxinfo 2>&1 | grep "OpenGL renderer string"`
opengl_software_version=`glxinfo 2>&1 | grep "OpenGL version string"`
printf "\n\n**Software versions:\n"
printf "  Kernel $kernel_version\n"
printf "  $opengl_renderer\n"
printf "  $opengl_software_version\n"
