#!/usr/bin/env ruby

##
# Calculate the new esteps and print the command to run.
#
# Based on 20mm calibration cube: https://www.thingiverse.com/thing:1278865
#
# Provide the current esteps and the observed dimensions in X Y Z order.
# Ex.
# ./3d_printer_new_esteps.rb 99.11 99.16 1593.77 20 20.05 20.05

require 'bigdecimal/util'

Dimensions = Struct.new(:x, :y, :z)

CURRENT_ESTEPS = Dimensions.new(*ARGV[0..2])
EXPECTED = Dimensions.new(20,20,20)
OBSERVED = Dimensions.new(*ARGV[3..5])

def new_esteps(expected, observed, current_esteps)
  ((expected.to_d / observed.to_d) * current_esteps.to_d).round(2)
end

esteps = Dimensions.new
[:x, :y, :z].each do |d|
  esteps.send(
    "#{d}=",
    new_esteps(EXPECTED.send(d), OBSERVED.send(d), CURRENT_ESTEPS.send(d))
    # (EXPECTED.send(d).to_d /  OBSERVED.send(d).to_d) * CURRENT_ESTEPS.send(d).to_d
  )
end

puts "Current ESteps: X#{CURRENT_ESTEPS.x} Y#{CURRENT_ESTEPS.y} Z#{CURRENT_ESTEPS.z}",
     "\nHere's the new esteps command to run:\n\n",
     "\tM92 X#{esteps.x.to_s('F')} Y#{esteps.y.to_s('F')} Z#{esteps.z.to_s('F')}\n\n"

puts "Then save with:", "\n\tM500"
