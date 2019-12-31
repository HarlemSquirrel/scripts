#!/usr/bin/env python

# https://github.com/raspberrypi/firmware/commit/404dfef3b364b4533f70659eafdcefa3b68cd7ae#commitcomment-31620480
# 1110000000000000010
# |||             |||_ under-voltage
# |||             ||_ currently throttled
# |||             |_ arm frequency capped
# |||_ under-voltage has occurred since last reboot
# ||_ throttling has occurred since last reboot
# |_ arm frequency capped has occurred since last reboot

import subprocess

GET_THROTTLED_CMD = 'vcgencmd get_throttled'
MESSAGES = {
    0: 'Under-voltage!',
    1: 'ARM frequency capped!',
    2: 'Currently throttled!',
    3: 'Soft temperature limit active',
    16: 'Under-voltage has occurred since last reboot.',
    17: 'Throttling has occurred since last reboot.',
    18: 'ARM frequency capped has occurred since last reboot.',
    19: 'Soft temperature limit has occurred'
}

class Logger:
    COLOR_ERROR = '\033[91m'
    COLOR_SUCCESS = '\033[92m'
    COLOR_WARNING = '\033[93m'
    COLOR_RESET = '\033[0m'

    @classmethod
    def error(cls, msg):
        print(cls.COLOR_ERROR + msg + cls.COLOR_RESET)

    @classmethod
    def success(cls, msg):
        print(cls.COLOR_SUCCESS + msg + cls.COLOR_RESET)

    @classmethod
    def warn(cls, msg):
        print(cls.COLOR_WARNING + msg + cls.COLOR_RESET)

print("Checking for throttling issues since last reboot...")

throttled_output = subprocess.check_output(GET_THROTTLED_CMD, shell=True)
throttled_binary = bin(int(throttled_output.split(b'=')[1], 0))

warnings = 0

for position, message in MESSAGES.items():
    # Check for the binary digits to be "on" for each warning message
    if len(throttled_binary) > position and throttled_binary[0 - position - 1] == '1':
        Logger.error(message)
        warnings += 1

if warnings == 0:
    Logger.success("Looking good!")
else:
    Logger.warn("Houston, we may have a problem!")
