#!/bin/bash

# https://dri.freedesktop.org/docs/drm/gpu/amdgpu.html#power-dpm-force-performance-level
echo low | sudo tee /sys/class/drm/card0/device/power_dpm_force_performance_level
