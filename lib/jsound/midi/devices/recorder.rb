module JSound::Midi::Devices

  # A Device that records incoming messages
  class Recorder < Device

    attr_reader :messages

    def initialize()
      clear
      stop
    end
    
    def clear
      @messages = []
    end
    
    def start
      @recording = true
    end
    
    def stop
      @recording = false
    end
    
    def recording?
      @recording
    end
    
    def <=(message)
      @messages << message if recording?
    end
    
  end
end