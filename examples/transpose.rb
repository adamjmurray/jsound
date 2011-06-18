#
# EXAMPLE: using a Transformer to transpose pitches up 2 octaves
#
require 'rubygems'
require 'jsound'
include JSound

# open the input & output matching the first & second command line arg, or default to the first available
input  = ARGV[0] ? Midi::INPUTS / ARGV[0] : Midi::INPUTS.open_first
output = ARGV[1] ? Midi::OUTPUTS/ ARGV[1] : Midi::OUTPUTS.open_first

# Using a block like this is most flexible way to implement a tranformer.
# This particular transformer has a nice shortcut. See the harmonize2.rb example
transposer = Midi::Devices::Transformer.new do |message|
  message.pitch += 24 if message.respond_to? :pitch # transpose up two octaves (24 semitones)
  message
end

input >> transposer >> output

sleep 5 while true # force script to keep running
