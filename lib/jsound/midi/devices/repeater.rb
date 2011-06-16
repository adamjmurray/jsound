module JSound
  module Midi
    module Devices

      # A device which repeats the input message to multiple outputs.
      class Repeater < Device

        # connect device(s) as the outputs for this device
        # @param [Enumberable, Device] the device or devices to connect, or nil to disconnect the currently connected device
        # @see {#>>}
        def output= device
          device = [device] if not device.is_a? Enumerable
          super
        end

        def message(message)
          if @output
            for device in @output
              device.message(message)
            end
          end
        end

      end

    end
  end
end