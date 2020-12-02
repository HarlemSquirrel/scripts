#!/bin/sh

##
# PulseAudio Virtual Audio Mapping Device
#
# Create a virtual output device that remaps to an input device.
#
# Point any combination of outputs from music player, OBS, etc. to the virtual output device
# and then use the remapped source as the input for broadcasting, recording, etc.
#

set -e

# Exit early if the VAMP is already created.
pactl list short | grep sink_name=VAMP && echo 'Already created' && exit

# Create the null (virtual) output device
# https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Modules/#module-null-sink
pactl load-module module-null-sink \
  sink_name=VAMP \
  sink_properties=device.description=VAMP

# Create the virtual input device
# https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Modules/#module-remap-source
pactl load-module module-remap-source \
  source_name=Remap-Source \
  master=VAMP.monitor

# pactl list short | grep VAMP

echo 'VAMP virtual output and input are ready to go!'