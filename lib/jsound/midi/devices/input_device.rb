module JSound
  module Midi
    module Devices

      # A device that receives messages from a system MIDI input port,
      # and passes the messages to any connected device.
      #
      # Available inputs are contained in the {INPUTS} list in the {Midi} module.
      #
      class InputDevice < JDevice

        # Wrap a javax.sound.midi.MidiDevice receiver to provide MIDI output.
        #
        # @note Typically you won't instantiate these directly. Instead, find an input via the {INPUTS} list in the {Midi} module.
        #
        def initialize(java_device)
          super(java_device, :input)
          @bridge = Bridge.new(self)
          java_device.transmitter.receiver = @bridge
        end

        def output=(device)
          super
          @bridge.output= device
        end

        # A subcomponent of {InputDevice} that implements javax.sound.midi.Receiver
        # by translating incoming Java MIDI Messages to Ruby Messages.
        class Bridge < Device
          include javax.sound.midi.Receiver

          def initialize(source_device)
            @source_device = source_device
          end

          # Receives incoming Java MIDI Messages, converts them to Ruby Messages,
          # and sends them to any connected devices.
          def send(java_message, timestamp=-1)
            self.message Message.from_java(java_message, :source => @source_device)
          rescue
            STDERR.puts $! if $DEBUG # otherwise this can get swallowed
            raise
          end

        end

      end

    end
  end
end