#!/usr/bin/env jruby
require 'rubygems'
require 'jsound'
include JSound::Midi

puts "ALL DEVICES:"
puts DEVICES
puts
puts "DEVICE VENDORS"
puts DEVICES.list_all(:vendor).uniq  # list_all will include "unknown" values
puts
puts "INPUT DESCRIPTIONS:"
puts INPUTS.list
puts
puts "OUTPUT DESCRIPTIONS:"
puts OUTPUTS.list
puts


# The following examples use SimpleSynth as an output.
# It's a free program for OS X available http://notahat.com/simplesynth
# I assume SimpleSynth's MIDI Source is set to "SimpleSynth virtual input"

# On Windows or Linux, I *think* you can just use a built-in MIDI output for your soundcard
# If you need to do anything special on Windows/Linux, let me know @ http://github.com/adamjmurray 
# and I'll update this example.


#######################################################
## FINDING INPUTS AND OUTPUTS
##
## Based on the input and output descriptions, 
## you can locate the first device matching a description:
#> OUTPUTS/'SimpleSynth'
#
## or just:
#> OUTPUTS/:SimpleSynth
#
## the / operator is a shortcut for
#> OUTPUTS.find /SimpleSynth/
#
## which has some more advanced options:
#> OUTPUTS.find :vendor => 'M-Audio'
#
## Use Strings for exact matches and Regexp for partial matches
## The find method returns the first match, find_all will return all of them: 
#> OUTPUTS.find_all :name => /(Novation|M-Audio)/
#
## All of these lookup options work for the INPUTS collection too:
#> INPUTS/'M-Audio'


######################################################
## ROUTING INPUTS TO OUTPUTS
##
## Once you have an input and an output, just connect them like so:
#> input = INPUTS/:Akai
#> output = OUTPUTS/:SimpleSynth
#> input >> output
#
## If you are sure the inputs and outputs exist, you can do it altogether:
#> INPUTS/:Akai >> OUTPUTS/:SimpleSynth


######################################################
## MONITORING INPUT
##
## Route to an instance of JSound::Midi::Devices::Monitor
#> input >> Devcies::Monitor.new


######################################################
## GENERATING NOTES
##
## See message_builder.rb for list of messages currently supported,
## including pitch_bend, control_change, channel_pressure, and more
#
# include JSound::Midi::Messages::Builder
# output = OUTPUTS/:SimpleSynth
# output.open  
# while(true)
#   output <= note_on(60,70)
#   sleep 1
#   output <= note_off(60)
#   sleep 1
# end
#
## Note that connecting to an output with >> will open the output automatically,
## but passing in Messages with << does not.
## That's why I explicitly call output.open in the above example.
