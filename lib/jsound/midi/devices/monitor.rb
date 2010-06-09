# A device that prints out all incoming MIDI message.

module JSound::Midi::Devices  
  class Monitor < Device
    include_package 'javax.sound.midi'
    include javax.sound.midi.Receiver
    include JSound::Midi::Messages
    
    def send(java_message, timestamp=-1)
      message = Message.from_java(java_message) 
      puts message.to_s
    rescue
      STDERR.puts $!
    end
    
    def <=(message)
      self.send(message)
    end
  end
end