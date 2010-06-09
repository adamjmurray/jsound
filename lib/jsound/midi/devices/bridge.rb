# An implementation of javax.sound.midi.Receiver, 
# which translates incoming Java MIDI Messages to Ruby Messages

module JSound::Midi::Devices  
  class Bridge < Device
    include_package 'javax.sound.midi'
    include javax.sound.midi.Receiver
    
    def send(java_message, timestamp=-1)
      self <=  JSound::Midi::Messages::Message.from_java(java_message) 
    rescue
      STDERR.puts $! if $DEBUG # otherwise this can get swallowed
      raise
    end

  end
end