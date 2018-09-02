#!/usr/bin/env bash

probe_cmd=''
directory=~/Music
log_file=~/music_file_errors.log

printf "Check all files in ${directory} with ffprobe at loglevel warning...\n"
printf "Begin check in ${directory}...\n" > $log_file

find $directory \( -name "*.flac" -o -name "*.mp3" -o -name "*.m4a" -o -name "*.m3u" \) \
  -type f -print -exec ffprobe -loglevel warning {} \; >> $log_file 2>&1

printf "Done! Results logged to ${log_file}\n"
