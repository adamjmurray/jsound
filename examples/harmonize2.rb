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

pass_through = Midi::Device.new
transposer = Midi::Devices::Transformer.new :pitch => lambda{|p| p + 3 }  # transpose up a minor third

input >> Midi.DeviceList(pass_through, transposer) >> output
# connecting a custom device list creates a graph of parallel chains:
# input ==> pass_through ==> output
# input ==> transposer ==> output

sleep 5 while true # force script to keep running
