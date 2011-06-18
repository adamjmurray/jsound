#
# EXAMPLE: generate and play some notes
#
require 'rubygems'
require 'jsound'
include JSound

generator = Midi::Devices::Generator.new

# open the output matching the first command line arg, or default to the first available
output = ARGV[0] ? Midi::OUTPUTS/ ARGV[0] : Midi::OUTPUTS.open_first

generator >> output

13.times do |interval|
  pitch = 60+interval
  generator.note_on pitch, 100
  sleep 0.5
  generator.note_off pitch
end
