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

# puts 'SYNTHS:',     JavaMidi::SYNTHS
# puts
# puts 'SEQUENCERS:', JavaMidi::SEQUENCERS
# puts
# puts 'INPUTS:',     JavaMidi::INPUTS
# puts
# puts 'OUTPUTS:',    JavaMidi::OUTPUTS

input  = MIDI_INPUTS.open /Akai/ # /Keystation/
output = MIDI_OUTPUTS.open /SimpleSynth/

input > output
input > MidiPrinter.new

java.lang.Thread.new {
  while(true)
    java.lang.Thread.sleep 2500
  end
}.start

rescue
  puts $!
end