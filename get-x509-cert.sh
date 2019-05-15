#!/bin/bash

if (( $# != 2 )); then
	printf "Usage:\n"
	printf "\t$0 example.com 443\n"
	exit 1
fi

HOSTNAME=$1
PORT=$2

openssl s_client -showcerts -connect $HOSTNAME:$PORT </dev/null 2>/dev/null | openssl x509 -outform PEM
