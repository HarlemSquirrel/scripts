#!/usr/bin/env python3

import subprocess
import urllib.request

BACKUP_OLD_MIRRORLIST_CMD = 'sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old'
MIRRORLIST_URL = "https://www.archlinux.org/mirrorlist/?country=CA&country=US&protocol=http&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on"
VALID_CONTENT_HEADER = '## Arch Linux repository mirrorlist'

def mirrorlist_invalid(content):
    return (VALID_CONTENT_HEADER not in new_mirrorlist) or ('\n#Server = http' not in content)

print("Fetching new mirrorlist...", end='')
response = urllib.request.urlopen(MIRRORLIST_URL).read()
# Uncomment the first 10 servers.
new_mirrorlist = str(response, 'utf-8').replace('#Server =', 'Server =', 10)
print("done.")

if mirrorlist_invalid(new_mirrorlist):
    print("It looks like we retrieved an invalid mirrorlist!")
    exit(1)

print("Moving current mirrorlist to mirrorlist.old")
subprocess.run(BACKUP_OLD_MIRRORLIST_CMD, shell=True, check=False).stdout

print("Saving new mirrorlist...", end='')
with open('/tmp/mirrorlist.new', 'w') as f:
    f.write(new_mirrorlist)

subprocess.run('sudo cp /tmp/mirrorlist.new /etc/pacman.d/mirrorlist', shell=True, check=False)
print("done! :)")
