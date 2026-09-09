#!/bin/bash

function get_power_usage() {
    cat /sys/class/drm/card0/device/hwmon/hwmon2/power1_input | awk '{print $1/1000000} watts'
}
echo "Power usage is"
get_power_usage

echo low | sudo tee /sys/class/drm/card0/device/power_dpm_force_performance_level

echo "Waiting for power usage to stabilize..."
sleep 3

echo "Power usage is now"
get_power_usage
