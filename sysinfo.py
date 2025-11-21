#!/usr/bin/env python3

import distro # https://distro.readthedocs.io/en/latest/
import platform # https://docs.python.org/3/library/platform.html
import subprocess
import re

print("\n **Motherboard**")
mb_manufacturer = open('/sys/devices/virtual/dmi/id/board_vendor', 'r').readline().rstrip()
mb_model = open('/sys/devices/virtual/dmi/id/board_name', 'r').readline().rstrip()
mb_board_version = open('/sys/devices/virtual/dmi/id/board_version', 'r').readline().rstrip()
mb_bios_date = open('/sys/devices/virtual/dmi/id/bios_date', 'r').readline().rstrip()
mb_bios_version = open('/sys/devices/virtual/dmi/id/bios_version', 'r').readline().rstrip()
print(f"Board Vender:  {mb_manufacturer}")
print(f"Board Model:   {mb_model}")
print(f"Board Version: {mb_board_version}")
print(f"BIOS Date:     {mb_bios_date}")
print(f"BIOS Version:  {mb_bios_version}")

print("\n **CPU Hardware**")
with open("/proc/cpuinfo") as f:
    cpuinfo = f.read()
cpu_model_name = re.search(r'model name.+', cpuinfo)[0].split(': ')[1]
cpu_core_count = re.search(r'cpu cores.+', cpuinfo)[0].split(': ')[1]
print(cpu_model_name)
print(cpu_core_count, "cores")

print("\n **GPU Hardware**")
# subprocess.run('glxinfo 2>&1 | grep "OpenGL renderer string"', shell=True, check=False).stdout
gpu_pci_ids = subprocess.run("lspci -v | grep VGA | cut -d ' ' -f 1", shell=True, check=False, capture_output=True, text=True).stdout.strip().split('\n')
for gpu_pci_id in gpu_pci_ids:
    # Capture info as a dictionary
    gpu_output = subprocess.run(f'lspci -s {gpu_pci_id} -v', shell=True, check=False, capture_output=True, text=True).stdout
    gpu_info = {}
    for line in gpu_output.splitlines():
        match = re.match(r'^(?P<id>[0-9a-fA-F:.]+)\s+(?P<desc>.+)$', line)
        if match:
            gpu_info['pci_id'] = match.group('id')
            key_value = match.group('desc')
        elif ':' in line:
            key_value = line
        key, value = key_value.split(':', 1)
        gpu_info[key.strip()] = value.strip()
    print(gpu_pci_id, gpu_info['Subsystem'], gpu_info['VGA compatible controller'], sep="\n  ")
# subprocess.run('lspci -d ::0300 -nn', shell=True, check=False).stdout

print("\n **Software**")
# subprocess.run('uname -r', shell=True, check=False).stdout
arch = platform.uname().machine
distro_name = distro.name(pretty=True) + ' - ' + distro.version(pretty=True)
kernel_version = platform.uname().release
print(f"{distro_name} {arch}")
print(f"Linux kernel {kernel_version}")
subprocess.run('glxinfo 2>&1 | grep "OpenGL version string"', shell=True, check=False).stdout
