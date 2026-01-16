#!/bin/sh

##
# Connect to serial console with screen over a USB serial adapter
#
# To end the session, press Ctrl+a followed by K.
# Alternatively, press Ctrl+a, type :quit and confirm it by pressing Enter.

# https://wiki.archlinux.org/title/Working_with_the_serial_console
# https://protectli.com/kb/com-port-tutorial/
# https://docs.netgate.com/pfsense/en/latest/hardware/connect-to-console.html

screen -S s1 /dev/ttyUSB0 115200

##
# From another terminal, send Function key presses
# https://www.gnu.org/software/screen/manual/screen.html

# F1
# screen -S s1 -X stuff "$(printf '\eOP')"

# F2
# screen -S s1 -X stuff "$(printf '\eOQ')"

# F11
# # screen -S s1 -X stuff "$(printf '\e[23~')"

# F12
# screen -S s1 -X stuff "$(printf '\e[24~')"
