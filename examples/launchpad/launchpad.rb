#!/usr/bin/env jruby --debug
require 'rubygems'
require 'jsound'
include JSound::Midi

# A quick prototype of monitoring input from a Novation Launchpad, 
# after translating it to something more meaningful than the raw MIDI messages.

# Note: I have to hit a button on the top row of my Launchpad before I can receive any input.


# A higher-level representation of the messages coming from the Launchpad
class LaunchpadMessage < Messages::Message
  def initialize(button_group, position, pressed, channel=0, source=nil)
    @type = :launchpad_button
    @button_group = button_group
    @position = position
    @pressed = pressed
    @data = {:button_group => button_group, :position => position, :pressed => pressed}
    @channel = channel
    @source = source
  end
end

# A device that converts the lower-level MIDI messages into LaunchpadMessages
class LaunchadTranslator < Devices::Device  
  def <=(message)
    case message.type    

    when :control_change
      button_group = :top
      pressed = (message.value > 0)
      position = message.control - 104       
      
    when :note_on
      # everything else
      pressed = (message.velocity > 0)
      value = message.pitch      
      row = value / 16
      col = value % 16
      if col > 7
        button_group = :right
        position = row
      else
        button_group = :grid
        position = [col,row]
      end  
    end
    
    super LaunchpadMessage.new(button_group, position, pressed, message.channel, message.source)    
  rescue
    puts $!
  end  
end


# And now that those classes are defined, 
# just hook up the Launchpad to a monitor, with the translator in between:
INPUTS.Launchpad >> LaunchadTranslator.new >> Devices::Monitor.new


# force the script to keep running (MIDI devices run in a background thread)
while(true)
  sleep 5
end
