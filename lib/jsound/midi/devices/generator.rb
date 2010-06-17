module JSound::Midi::Devices

  # A device which provides methods for generating MIDI command messages.
  # See JSound::Midi::Messages::Builder for the available methods.
  class Generator < Device
    include JSound::Midi::Messages
    
    # For all the methods defined in the Builder module (note_on, pitch_bend, control_change, etc),
    # define a corresponding device method that constructs the message and sends the connected device
    Builder.private_instance_methods.each do |method|
      define_method(method) do |*args|
        message = Builder.send(method, *args)
        self <= message
      end
    end
    
  end
end