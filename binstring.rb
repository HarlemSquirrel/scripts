#!/usr/bin/env ruby

###
# BinString
#
# Convert between bit strings and character strings.
#
module BinString
  class << self
    def chars_to_bin_string(input)
      bin_strings = []
      input.each_char { |char| bin_strings << char.unpack('B8')[0] }
      bin_strings.join(' ')
    end

    def bin_string_to_chars(input)
      input.split(/\s/).map { |bs| bs.to_i(2) }.pack('C*')
    end
  end
end

INPUT = ARGV.join(' ')

if INPUT.to_s.empty?
  puts 'Usage:',
       "  binstring.rb 'Hello'",
       "  binstring.rb '01001000 01100101 01101100 01101100 01101111'"
  exit 1
end

# Detect input type
if INPUT.match? /((0|1){8}\s+)+/
  puts BinString.bin_string_to_ascii(INPUT)
else
  puts BinString.ascii_to_bin_string(INPUT)
end
