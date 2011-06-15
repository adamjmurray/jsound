module JSound
  module Midi

    # A device that can transmit and/or receive messages (typically MIDI messages).
    # This default implementation simply passes through all messages.
    class Device
      include JSound::Mixins::TypeFromClassName

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
        # The base Device behaves like a 'pass through'
        @type ||= (self.class == Device ? :pass_through : self.class.type)
      end

      def receiver
        @receiver
      end

      # connect this device's output to a MIDI message receiver
      def receiver=(receiver)
        @receiver = receiver
      end
      alias :>> :receiver=

      # send a message to this device
      def message(message)
        # default behavior is to pass the message to any connected receiver
        @receiver.message message if @receiver
      end

      # send a message to this device. shortcut for #message
      def <=(message)
        message(message)
      end

      def to_s
        "MIDI #{type} device"
      end

    end

  end
end