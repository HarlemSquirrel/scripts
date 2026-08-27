# Lulzbot TAZ 6

## Gcode resources

https://gitlab.com/lulzbot3d/cura-le/cura-lulzbot/-/blob/master/resources/gcodes/lulzbot_taz6_start.gcode
https://gitlab.com/lulzbot3d/cura-le/cura-lulzbot/-/blob/master/resources/gcodes/lulzbot_taz6_end.gcode

https://github.com/Ultimaker/Cura/blob/main/resources/definitions/lulzbot_taz_pro_dual.def.json

## Settings resources

https://gitlab.com/lulzbot3d/cura-le/cura-lulzbot/-/blob/master/resources/definitions/lulzbot_taz6.def.json
https://gitlab.com/lulzbot3d/cura-le/cura-lulzbot/-/blob/master/resources/extruders/lulzbot_taz6_extruder.def.json

## Factory settings

Z Offset: -1.250
Esteps/mm: +0830.0

Baudrate: 250000

## Build plate

X: 280mm
Y: 280mm
Z: 250mm

Heated bed

Gcode flavor: marlin

## Printhead

X min: -20mm
Y min: -10mm
X max: 10mm
Y max: 10mm

Gantry height 250 mm

Number of extruders 1

Apply Extruder offsets to GCode: yes


## Start G-code

See `./start.gcode`

## End G-code

```gcode
M400                                              ; wait for moves to finish
M140 S{material_part_removal_temperature}         ; start bed cooling
M104 S0                                           ; disable hotend
M107                                              ; disable fans
G91                                               ; relative positioning
G1 E-1 F300                                       ; filament retraction to release pressure
G1 Z20 E-5 X-20 Y-20 F3000                        ; lift up and retract even more filament
G1 E6                                             ; re-prime extruder
M117 Cooling please wait                          ; progress indicator message on LCD
G90                                               ; absolute positioning
G1 Y0 F3000                                       ; move to cooling position
M190 R{material_part_removal_temperature}         ; wait for bed to cool down to removal temp
G1 Y280 F3000                                     ; present finished print
M140 S{material_keep_part_removal_temperature_t}  ; keep temperature or cool downs
M77					                              ; stop GLCD timer
M84                                               ; disable steppers
G90                                               ; absolute positioning
M117 Print Complete.                              ; print complete message

```

## Extruder

Have had the m175v2 in place since like 2024

### M175 v2

Nozzle size: 0.5 mm
Compatible material diamter: 1.75mm
Nozzle offset X: 0mm
Nozzle offset Y: 0mm
Cooling Fan Number: 0

### Default extruder

Nozzle size: 0.5 mm
Compatible material diamter: 2.85mm
Nozzle offset X: 0mm
Nozzle offset Y: 0mm

Extruder start/end gcode: N/A



## PID autotune

https://www.3dmakerengineering.com/blogs/3d-printing/pid-tuning-marlin-firmware
https://marlinfw.org/docs/gcode/M303.html

```gcode
M303 E0 S205 C10 ; This will run autotune for extruder 1 (Extruder 1 is E0) at 205°C for a total of 10 iterations.


M303 E0 S245 C5 U1 ; Autotune 5 times at 245°C and use the result
```

```gcode
M303 E-1 S60 C10 ; This will run autotune for the heated bed at 60°C for a total of 10 iterations.
```

### Results 2022-07-29

#### Extruder

Recv: PID Autotune finished! Put the last Kp, Ki and Kd constants from below into Configuration.h
Recv: #define DEFAULT_Kp 55.32
Recv: #define DEFAULT_Ki 5.24
Recv: #define DEFAULT_Kd 146.15
Recv: ok P15 B3

```gcode
M301 P55.32 I5.24 D146.15 ; Sets hotend PID parameter
M500 ; save
```

#### Bed

Recv: PID Autotune finished! Put the last Kp, Ki and Kd constants from below into Configuration.h
Recv: #define DEFAULT_bedKp 112.27
Recv: #define DEFAULT_bedKi 20.15
Recv: #define DEFAULT_bedKd 416.94
Recv: ok P15 B3

```gcode
M304 P112.27 I20.15 D416.94 ; Sets heated bed PID parameter to new values
M500 ; save
```



## Run this test from the console, see how level your bed is in comparison to each washer:

```
M420 S0 ; shut off auto-leveling
G28 X Y ; home the X & Y axis
G28 Z ; home the Z axis
G29 V4 ; Perform Auto Leveling Test, verbose output
```

```
< [19:36:52] Bed X: -3.000 Y: -9.000 Z: 0.665
< [19:37:08] Bed X: 282.000 Y: -9.000 Z: 0.483
< [19:37:26] Bed X: 282.000 Y: 291.000 Z: 0.586
< [19:37:44] Bed X: -3.000 Y: 291.000 Z: 0.410
```

X: Y: is the position of the washer that the nozzle is at when probing the washer.
The Z value is what you’re interested in here. Run this simple test to see how level your bed is.
