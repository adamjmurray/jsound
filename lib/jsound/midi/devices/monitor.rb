module JSound::Midi::Devices  

  # A device that prints out all incoming MIDI message.
  class Monitor < Device
    def message(message)
      puts message.to_s
    end
  end
end