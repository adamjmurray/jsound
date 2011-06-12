#!/usr/bin/env jruby
require 'rubygems'
require 'jsound'
include JSound::Midi

INPUTS.each do |input| 
  input.open
  input >> Devices::Monitor.new
end

# force the script to keep running (MIDI devices run in a background thread)
while(true)
  sleep 5
end
  