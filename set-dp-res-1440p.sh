#!/bin/bash

cvt 2560 1440

xrandr --newmode "2560x1440_60.00"  312.25  2560 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync

xrandr --addmode DisplayPort-0 2560x1440_60.00

xrandr --output DisplayPort-0 --mode 2560x1440_60.00

notify-send "You should be all set at 1440p, buddy!"
