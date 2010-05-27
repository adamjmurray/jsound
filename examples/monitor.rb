#!/usr/bin/env jruby
begin
$: << File.dirname(__FILE__)+'/../lib'
require 'jsound'
include JSound::Midi

INPUTS.each do |input| 
  input >> Devices::Monitor.new
end

# force the script to keep running (MIDI devices run in a background thread)
while(true)
  sleep 5
end
  
rescue
  puts $!
end