module JSound
  module Midi
    module Devices

      # A Java-provided MIDI device (wraps javax.sound.midi.MidiDevice objects)
      class JDevice < Device

        # the javax.sound.midi.MidiDevice.Info object for this java device
        attr_reader :info

        # the description of this device
        # @return [String]
        attr_reader :description

        attr_reader :type

        def self.open_devices
          @@open_devices ||= []
        end
        at_exit do
          # Close all open devices so we don't hang the program at shutdown time
          for device in JDevice.open_devices
            device.close
          end
        end

        def initialize(java_device, type)
          @java_device = java_device
          @info = @java_device.deviceInfo
          @description = @info.description
          @type = type
        end

        def self.from_java(java_device)
          case java_device
          when javax.sound.midi.Sequencer then type = :sequencer
          when javax.sound.midi.Synthesizer then type = :synthesizer
          else
            # This assumes a single device cannot be both an input and an output:
            if java_device.maxTransmitters != 0
              return InputDevice.new(java_device)
            elsif java_device.maxReceivers != 0
              return OutputDevice.new(java_device)
            else
              type = :unknown
            end
          end
          new java_device, type
        end

        def open
          unless @java_device.open?
            puts "Opening #{to_s}"
            @java_device.open
            self.class.open_devices << self
          end
        end

        def close
          if @java_device.open?
            puts "Closing #{to_s}"
            @java_device.close
            self.class.open_devices.delete(self)
          end
        end

        def method_missing(sym, *args, &block)
          if @java_device.respond_to? sym
            @java_device.send(sym, *args, &block)
          else
            @info.send(sym, *args, &block)
          end
        end

        def respond_to?(sym)
          super or @java_device.respond_to? sym or info.respond_to? sym
        end

        def [](field)
          send field
        end

        def to_s
          "#{super}: #{info.description}"
        end

        def inspect
          to_s
        end

      end

    end
  end
end