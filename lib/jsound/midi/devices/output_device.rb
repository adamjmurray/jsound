module JSound
  module Midi
    module Devices

      # A device that sends all it's received messages to a system MIDI output port.
      #
      # Available outputs are contained in the {OUTPUTS} list in the {Midi} module.
      #
      class OutputDevice < JDevice

        # Wrap a javax.sound.midi.MidiDevice transmitter to provide MIDI output.
        #
        # @note Typically you won't instantiate these directly. Instead, find an output via the {OUTPUTS} list in the {Midi} module.
        #
        def initialize(java_device)
          super(java_device, :output)
        end

        def output= device
          raise "#{self.class} cannot be assigned an output"
        end

        def message(message)
          # unwrap the ruby message wrapper, if needed:
          message = message.to_java if message.respond_to? :to_java

          # Use java_send to call Receiver.send() since it conflicts with Ruby's built-in send method
          # -1 means no timestamp, so we're not supporting timestamps
          @java_device.receiver.java_send(:send, [javax.sound.midi.MidiMessage, Java::long], message, -1)
        end

      end

    end
  end
end
