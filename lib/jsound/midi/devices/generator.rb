module JSound
  module Midi
    module Devices

      # A device which provides methods for generating MIDI command messages.
      # @see JSound::Midi::MessageBuilder
      class Generator < Device

        # For all the methods defined in the MessageBuilder module (note_on, pitch_bend, control_change, etc),
        # define a corresponding device method that constructs the message and sends the connected device
        MessageBuilder.private_instance_methods.each do |method|
          define_method(method) do |*args|
            message = MessageBuilder.send(method, *args)
            self.message message
          end
        end

      end

    end
  end
end