#!/usr/bin/env bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

if [ $# -eq 0 ]; then
  printf "Usage:\n"
  printf "  $0 http://example.com [interval]\n"
  exit 1
fi

URL=$1

if [[ $# -eq 2 ]]; then
  INTERVAL=$2
else
  INTERVAL=1
fi

printf "Checking status of $URL every $INTERVAL second(s)...\n"
printf "Date                            | Code | Duration\n"

for i in `seq 1 1000`;
do
  date=`date`
  result=`curl --insecure -X GET -s -o /dev/null -w "%{http_code}    %{time_total}s" $URL`
  if [[ $result =~ ^200.* ]]; then
    color=$GREEN
  else
    color=$RED
  fi
  printf "$date  $color $result $NC\n"
  sleep $INTERVAL
done
