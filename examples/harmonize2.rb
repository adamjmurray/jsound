#
# EXAMPLE: Harmonize pitches by adding a second transposed pitch
#
# Alternate implementation, compare with the harmonize.rb example.
# This approach simplifies the transformer, but requires a more complex device graph.
#
require 'rubygems'
require 'jsound'
include JSound

# open the input & output matching the first & second command line arg, or default to the first available
input  = ARGV[0] ? Midi::INPUTS / ARGV[0] : Midi::INPUTS.open_first
output = ARGV[1] ? Midi::OUTPUTS/ ARGV[1] : Midi::OUTPUTS.open_first

transposer = Midi::Devices::Transformer.new :pitch => lambda{|p| p + 3 }  # transpose up a minor third

repeater = Midi::Devices::Repeater.new

input >> repeater >> [transposer, transposer >> output]
# this is a shortcut for these 2 statements:
# input >> repeater >> [transposer, output]
# transposer >> output

sleep 5 while true # force script to keep running
