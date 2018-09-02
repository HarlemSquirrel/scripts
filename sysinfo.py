#!/usr/bin/env python
import subprocess

print('')
print(" **Motherboard**")
mb_manufacturer = open('/sys/devices/virtual/dmi/id/board_vendor', 'r').readline().rstrip()
mb_model = open('/sys/devices/virtual/dmi/id/board_name', 'r').readline().rstrip()
mb_bios_version = open('/sys/devices/virtual/dmi/id/bios_version', 'r').readline().rstrip()
print(mb_manufacturer)
print(mb_model)
print(f"BIOS Version: {mb_bios_version}")

print('')
print(" **CPU Hardware**")
subprocess.run('uname -m', shell=True, check=False).stdout
subprocess.run('grep "model name" /proc/cpuinfo | head -1 | sed \'s/^[^:]*: //\'', shell=True, check=False).stdout

print('')
print(" **GPU Hardware**")
subprocess.run('glxinfo 2>&1 | grep "OpenGL renderer string"', shell=True, check=False).stdout
subprocess.run('lspci -d ::0300 -nn', shell=True, check=False).stdout

print('')
print(" **Software**")
subprocess.run('uname -r', shell=True, check=False).stdout
subprocess.run('glxinfo 2>&1 | grep "OpenGL version string"', shell=True, check=False).stdout
