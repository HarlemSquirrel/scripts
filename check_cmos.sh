#!/bin/sh

##
# Script to check the CMOS bettery on FreeBSD. Exits with 0 if the battery is OK, and 2 if it is not.
##

val=$(sysctl -n machdep.atrtc_power_lost 2>/dev/null || echo "")
if [ "$val" = "1" ]; then
  echo "CMOS battery/RTC power lost"
  exit 2
else
  echo "CMOS battery OK"
  exit 0
fi
