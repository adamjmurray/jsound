#!/Users/adam/bin/jruby/bin/jruby
require 'java_midi'
include JavaMidi

begin

class MidiPrinter
  require 'java'
  include javax.sound.midi.Receiver
  
  def send(msg, timestamp)
    puts "MIDI MSG: #{msg} @#{timestamp}"
  end
end

# puts 'MIDI DEVICE VENDORS: ', MIDI_DEVICES.list(:vendor).uniq
# puts
# puts 'SYNTHS:',     MIDI_SYNTHS
# puts
# puts 'SEQUENCERS:', MIDI_SEQUENCERS
# puts
# puts 'INPUTS:',     MIDI_INPUTS
# puts
# puts 'OUTPUTS:',    MIDI_OUTPUTS


input  = MIDI_INPUTS / :Akai

output = MIDI_OUTPUTS / :SimpleSynth


if input
  input >> MidiPrinter.new

  input >> output if output
end


java.lang.Thread.new {
  while(true)
    java.lang.Thread.sleep 2500
  end
}.start

rescue
  puts $!
end