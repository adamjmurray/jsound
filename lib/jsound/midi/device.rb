module JSound
  module Midi

    # A device that can transmit and/or receive messages (typically MIDI messages).
    # This default implementation simply passes through all messages.
    class Device
      include JSound::Mixins::TypeFromClassName

      # Open the device and allocate the needed resources so that it can send and receive messages
      # @note this operation is typically only relevant for Java-based devices such as {Devices::InputDevice} and {Devices::OutputDevice}
      # @see DeviceList#open
      def open
      end

      # return true if this device is currently open
      def open?
        # typically, ruby devices are always open, subclasses might not be
        true
      end

      # Close the device and free up any resources used by this device.
      # @note this operation is typically only relevant for Java-based devices such as {Devices::InputDevice} and {Devices::OutputDevice}
      def close
      end

      def type
        # The base Device behaves like a 'pass through'
        @type ||= (self.class == Device ? :pass_through : self.class.type)
      end

      # the device connected to this device's output
      # @return [Device] the connected device, or nil if nothing is connected
      def output
        @output
      end

      # connect a device as the output for this device
      # @param [Device] the device to connect, or nil to disconnect the currently connected device
      # @see {#>>}
      def output= device
        @output = device
      end

      # Connect a device as the output for this device. shortcut for {#output=}
      # @param [Device] the device to connect, or nil to disconnect the currently connected device
      # @see {#output=}
      def >> device
        self.output= device
      end

      # Send a message to this device
      # @param [Message]
      # @see #<=
      def message(message)
        # default behavior is to pass the message to any connected output
        @output.message(message) if @output
      end

      # send a message to this device. shortcut for {#message}
      # @see #message
      def <=(message)
        message(message)
      end

      def to_s
        "MIDI #{type} device"
      end

    end

  end
end