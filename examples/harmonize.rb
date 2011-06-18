#
# EXAMPLE: Harmonize pitches by adding a second transposed pitch
#
require 'rubygems'
require 'jsound'
include JSound

# open the input & output matching the first & second command line arg, or default to the first available
input  = ARGV[0] ? Midi::INPUTS / ARGV[0] : Midi::INPUTS.open_first
output = ARGV[1] ? Midi::OUTPUTS/ ARGV[1] : Midi::OUTPUTS.open_first

harmonizer = Midi::Devices::Transformer.new do |message|
  if message.respond_to? :pitch
    transposed = message.clone # messages are mutable, so we have to clone them to keep the original intact
    transposed.pitch += 3 # transpose up a minor third
    [message, transposed]

  else # pass through everything else
    message
  end
end

input >> harmonizer >> output

sleep 5 while true # force script to keep running
