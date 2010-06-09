# A device that prints out all incoming MIDI message.

module JSound::Midi::Devices  
  class Monitor < Device
    def <=(message)
      puts message.to_s
    end
  end
end