#!/bin/bash

##
# Listen for network activity to/from the provided host
# using lsof which will show the command and user associated
# with the connection.

# Load helper functions
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
source $SCRIPTPATH/helper_functions.sh

if [ $# -eq 0 ]; then
	colorprintf red "Please supply a host.\n"
	printf "Ex:\n  $0 archlinux.org [seconds_to_listen]\n\n"
	exit 1
fi

host="$1"

if [ $# -eq 1 ]; then
	# Default to 10 seconds
	duration=10
else
	duration=$2
fi

colorprintf yellow "Listening for connections to $host for $duration seconds...\n"

let "end = $SECONDS + $duration"

while [ $SECONDS -lt $end ]; do
	lsof -i @"$host"
	sleep 0.1
done
