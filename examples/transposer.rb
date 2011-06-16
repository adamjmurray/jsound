#!/usr/bin/env jruby
require 'rubygems'
require 'jsound'
include JSound::Midi
include Devices

transposer = Transformer.new do |message|
  message.pitch += 24 if message.respond_to? :pitch # transpose up two octaves
  message
end

# Adjust the INPUTS and OUTPUTS as needed to use the devices you want:
INPUTS.open_first >> transposer >> OUTPUTS.open_first
# For example, to send my Akai keyboard through the harmonizer to the OS X IAC bus, I can do:
# INPUTS.Akai >> transposer >> OUTPUTS.IAC

# force the script to keep running (MIDI devices run in a background thread)
while(true)
  sleep 5
end