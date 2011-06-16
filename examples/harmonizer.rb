#!/usr/bin/env jruby
require 'rubygems'
require 'jsound'
include JSound::Midi
include Devices

harmonizer = Transformer.new do |message|
  if message.respond_to? :pitch
    transposed = message.clone # messages are mutable, so we have to clone them to keep the original in tact
    transposed.pitch += 3
    [message, transposed]
  else
    message # pass through everything else
  end
end

# Adjust the INPUTS and OUTPUTS as needed to use the devices you want:
INPUTS.open_first >> harmonizer >> OUTPUTS.open_first
# For example, to send my Akai keyboard through the harmonizer to the OS X IAC bus, I can do:
# INPUTS.Akai >> harmonizer >> OUTPUTS.IAC

# force the script to keep running (MIDI devices run in a background thread)
while(true)
  sleep 5
end