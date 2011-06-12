module JSound::Midi::Devices  

  # A Device that implements javax.sound.midi.Receiver
  # and translates incoming Java MIDI Messages to Ruby Messages
  class Bridge < Device
    include_package 'javax.sound.midi'
    include javax.sound.midi.Receiver
    
    def initialize(source_device)
      @source_device = source_device
    end
    
    # Receives incoming Java MIDI Messages, converts them to Ruby Messages,
    # and sends them to any connected devices.
    def send(java_message, timestamp=-1)
      message = JSound::Midi::Messages::Message.from_java(java_message) 
      message.source = @source_device
      self.message message
    rescue
      STDERR.puts $! if $DEBUG # otherwise this can get swallowed
      raise
    end

  end
end