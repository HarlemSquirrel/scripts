;This G-Code has been generated specifically for the LulzBot TAZ 6 with standard extruder
;Modified by HarlemSquirrel for Cura 5.1
;https://forum.lulzbot.com/t/cura-5-1-and-taz-6/24720/7

M73 P0 ; clear GLCD progress bar
M75 ; start GLCD timer
G26 ; clear potential 'probe fail' condition
M107 ; disable fans
G90 ; absolute positioning
M420 S0 ; disable previous leveling matrix

M117 Heating... ; LCD status message
M140 S{material_bed_temperature_layer_0} ; start bed heating up
M104 S{material_print_temperature_layer_0} ; set hotend temp immediately (parallel heat!)

G28 XY                                      ; home X and Y
G1 X-19 Y258 F1000                          ; move to safe homing position
M109 R{material_print_temperature_layer_0} ; wait for extruder to reach temp

M82 ; set extruder to absolute mode
G92 E0 ; set extruder position to 0
G1 E-15 F100 ; retract filament 10mm

;M206 X0 Y0 Z0              ; uncomment to adjust wipe position (+X ~ nozzle moves left)(+Y ~ nozzle moves forward)(+Z ~ nozzle moves down)
G12 ; wiping sequence
M106 S255 ; turn on fan to blow away fuzzies
G4 S5 ; wait 5 seconds
M107 ; turn off fan
M206 X0 Y4 Z0 ; reseting stock nozzle position ### CAUTION: changing this line can affect print quality ###
G1 Z10 F5000                                ; raise nozzle after wipe

; un-comment to get auto-leveling
;G1 X-10 Y293 F4000 ; move above first probe point
;M204 S100 ; set probing acceleration
;G29 ; start auto-leveling sequence
;M420 S1 ; activate bed level matrix
;M204 S500 ; restore standard acceleration

G1 X0 Y0 Z15 F5000 ; move to origin
G4 S1 ; pause
M190 R{material_bed_temperature_layer_0} ; wait for bed to reach printing temp

G1 Z2 E0 F75 ; prime tiny bit of filament into the nozzle
M400 ; wait for moves to finish
M117 TAZ 6 Printing... ; progress indicator message on LCD
