#!/usr/bin/env python
import subprocess

groups = 'docker,uucp'
username = input('Enter the username to add to groups: ')

subprocess.run(f"sudo usermod -aG {groups} {username}", shell=True, check=False).stdout
print(f"Added {username} to {groups}")
