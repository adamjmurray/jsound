# An implementation of javax.sound.midi.Receiver, 
# which translates incoming Java MIDI Messages to Ruby Messages

module JSound::Midi::Devices  
  class Bridge < Device
    include_package 'javax.sound.midi'
    include javax.sound.midi.Receiver
    
    def initialize(source_device)
      @source_device = source_device
    end
    
    def send(java_message, timestamp=-1)
      message = JSound::Midi::Messages::Message.from_java(java_message) 
      message.source = @source_device
      self <= message
    rescue
      STDERR.puts $! if $DEBUG # otherwise this can get swallowed
      raise
    end

  end
end