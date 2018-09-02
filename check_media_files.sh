#!/usr/bin/env bash

find $1 \( -name "*.flac" -o -name "*.mp3" -o -name "*.m4a" \) -type f | while read -r filename; do
# for filename in $1; do
  # ffmpeg -v error -i "$line" -f null - > /dev/null 2>&1 || printf " FAILED - $line \n"
  if ffprobe -loglevel error "$filename" ; then
    printf '.'
  else
    printf "\n FAILED - $filename \n"
  fi
done

printf "done!\n"
