#!/bin/bash

CPU_COUNTS=$(nproc)
#
#    --cpu 8 – matches your 8‑core Ryzen 7 9800X3D.
#    --vm 4 – four memory workers each allocating ~90 % of RAM.
#    --metrics-brief prints a quick summary at the end.

# Run a mixed CPU+memory stress for 10 minutes (adjust time as you wish)
# https://github.com/ColinIanKing/stress-ng
sudo stress-ng \
  --cpu "$CPU_COUNTS" \
  --vm $((CPU_COUNTS/2)) \
  --vm-bytes 90% \
  --timeout 600s \
  --klog-check \
  --metrics-brief \
  --thermalstat 30 \
  --tz
