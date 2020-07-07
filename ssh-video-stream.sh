#!/bin/bash

##
# Stream web camera video from a remote Linux box over SSH
# using ffmpeg and mplayer
#

remote_host=$1

ssh $remote_host ffmpeg -an -f video4linux2 -s 1280x720 -i /dev/video0 -r 10 -b:v 500k -f matroska - | mplayer - -idle -demuxer matroska
