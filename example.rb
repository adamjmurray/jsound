#!/Users/adam/bin/jruby
# Point the above path to your jruby executable, or run this script with `jruby example.rb`

$: << File.dirname(__FILE__)+'/lib'
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

# Based on the input and output descriptions, 
# you can locate the first device matching a description
# and connect the I/O as follows:
#INPUTS/:Akai >> OUTPUTS/:SimpleSynth
# or use more flexible locators such as:
#INPUTS.find(:vendor => 'M-Audio') >> OUTPUTS.find(/IAC Driver/)

# INPUTS/:Akai >> Monitor.new
