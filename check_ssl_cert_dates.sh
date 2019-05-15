#!/bin/bash

## Check SSL certificate expiration dates for passed in hosts
#
# Example:
# ./check_ssl_cert_dates.sh localhost remotehost www.google.com

# for host in "$hosts[@]"; do
for host in "$@"; do
  printf "\n$host\n"
  echo | openssl s_client -servername $host -connect $host:443 2>/dev/null | openssl x509 -noout -dates
done
