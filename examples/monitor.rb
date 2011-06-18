#
# EXAMPLE: Monitor all MIDI inputs
#
require 'rubygems'
require 'jsound'
include JSound

monitor = Midi::Devices::Monitor.new

for input in Midi::INPUTS
  input.open
  input >> monitor
end

sleep 5 while true # force script to keep running
