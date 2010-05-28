# A device that can transmit and/or receive MIDI messages
# This default implementation simply passes through all messages

module JSound::Midi::Devices
  class Device

    # open the device and allocate the needed resources so that it can send and receive messages
    def open
    end
    
    # return true if this device is currently open
    def open?
      # typically, ruby devices are always open, subclasses might not be
      true
    end
    
    # close the device and free up any resources used by this device
    def close
    end
    
    def type
      @type ||= :pass_through
    end
    
    def receiver
      @receiver
    end
        
    # connect this device's output to a MIDI message receiver
    def receiver=(receiver)      
      @receiver = receiver
    end
    alias >> receiver=
    
    # send a message to this device
    def <=(message)
      # default behavior is to pass the message to any connected receiver
      @receiver <= message if @receiver
    end
    
    def to_s
      "MIDI #{@type} device"
    end
     
  end
end