#! /usr/bin/env python3

##
# Patch the file to launch Valheim with mods from r2modman
#
# https://github.com/ebkr/r2modmanPlus/issues/1534
# https://github.com/BepInEx/BepInEx/issues/1032
#

import glob
import os
from pathlib import Path

old_statement = """
# Special case: program is launched via Steam
# In that case rerun the script via their bootstrapper to ensure Steam overlay works
if [ "$2" = "SteamLaunch" ]; then
    cmd="$1 $2 $3 $4 $0"
    shift 4
    exec $cmd $@
    exit
fi
"""
replacement = """
# https://github.com/BepInEx/BepInEx/issues/1032#issuecomment-2585547358
if [ "$4" = "SteamLaunch" ]; then
    cmd="$1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} $0"
    shift 11
    exec $cmd $@
    exit
fi
"""

home = Path('~').expanduser()
for filename in glob.glob(f"{home}/.config/r2modmanPlus-local/Valheim/profiles/*/start_game_bepinex.sh"):
    content = open(filename).read()

    if replacement in content:
        print(f"File {filename} is already patched")
        exit

    print(f"Patching {filename}")

    # Backup the old one
    os.rename(filename, f"{filename}.bak")

    new_content = content.replace(old_statement, replacement)

    with open(filename, 'w') as f:
        f.write(new_content)

    print("Done!")
