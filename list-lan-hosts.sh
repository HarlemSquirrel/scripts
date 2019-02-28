#!/bin/bash

# Load helper functions
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
source $SCRIPTPATH/helper_functions.sh

if [ $# -eq 0 ]; then
	colorprintf red "Please supply an IP range.\n"
	printf "Ex:\n  $0 192.168.1.0/24\n\n"
	exit 1
fi

IP_RANGE="$1"

if [ "$EUID" -ne 0 ]; then
	colorprintf orange "WARNING: This list may be incomplete when not running as root.\n"
fi

nmap -sP $IP_RANGE
