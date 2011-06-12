module JSound::Midi::Devices

  # A Device that records incoming messages
  class Recorder < Device

    # The recorded messages
    attr_reader :messages

    def initialize()
      clear
      stop
    end
    
    # clear any recorded messages
    def clear
      @messages = []
    end
    
    # start recording
    def start
      @recording = true
    end
    
    # stop recording
    def stop
      @recording = false
    end
    
    # true if this object is currently recording
    def recording?
      @recording
    end
    
    def message(message)
      @messages << message if recording?
    end
    
  end
end