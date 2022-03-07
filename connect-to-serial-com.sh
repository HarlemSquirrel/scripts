#!/bin/sh

##
# Connect to serial console with screen over a USB serial adapter
#
# To end the session, press Ctrl+a followed by K.
# Alternatively, press Ctrl+a, type :quit and confirm it by pressing Enter.

# https://wiki.archlinux.org/title/Working_with_the_serial_console
# https://protectli.com/kb/com-port-tutorial/
# https://docs.netgate.com/pfsense/en/latest/hardware/connect-to-console.html

screen /dev/ttyUSB0 115200
