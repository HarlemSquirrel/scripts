#!/usr/bin/env python

import distro # https://distro.readthedocs.io/en/latest/
import platform # https://docs.python.org/3/library/platform.html
import subprocess
import re

print("\n **Motherboard**")
mb_manufacturer = open('/sys/devices/virtual/dmi/id/board_vendor', 'r').readline().rstrip()
mb_model = open('/sys/devices/virtual/dmi/id/board_name', 'r').readline().rstrip()
mb_bios_version = open('/sys/devices/virtual/dmi/id/bios_version', 'r').readline().rstrip()
print(mb_manufacturer)
print(mb_model)
print(f"BIOS Version: {mb_bios_version}")

print("\n **CPU Hardware**")
with open("/proc/cpuinfo") as f:
    cpuinfo = f.read()
cpu_model_name = re.search(r'model name.+', cpuinfo)[0].split(': ')[1]
cpu_core_count = re.search(r'cpu cores.+', cpuinfo)[0].split(': ')[1]
print(cpu_model_name)
print(cpu_core_count, "cores")

print("\n **GPU Hardware**")
subprocess.run('glxinfo 2>&1 | grep "OpenGL renderer string"', shell=True, check=False).stdout
subprocess.run('lspci -d ::0300 -nn', shell=True, check=False).stdout

print("\n **Software**")
# subprocess.run('uname -r', shell=True, check=False).stdout
arch = platform.uname().machine
distro_name = distro.name(pretty=True) + ' - ' + distro.version(pretty=True)
kernel_version = platform.uname().release
print(f"{distro_name} {arch}")
print(f"Linux kernel {kernel_version}")
subprocess.run('glxinfo 2>&1 | grep "OpenGL version string"', shell=True, check=False).stdout
