# A single MIDI device
# Wraps javax.sound.midi.MidiDevice objects

module JSound
  
  module Midi
    
    class Device      
      include_package 'javax.sound.midi'      
      include Util
      
      attr_reader :type      
      
      def self.open_devices
        @@open_devices ||= []
      end
      at_exit do
        # Close all open devices so we don't hang the program at shutdown time
        for device in Device.open_devices
          device.close
        end
      end         
      
      def initialize(device)
        @device = device        
        
        # set the type:
        case device
        when Sequencer then @type = :sequencer
        when Synthesizer then @type = :synthesizer
        else
          # This assumes a single device cannot be both an input and an output:
          if device.maxTransmitters != 0
            @type = :input
          elsif device.maxReceivers != 0
            @type = :output
          else
            @type = :unknown
          end
        end
      end

      def info
        @device.deviceInfo
      end
      
      def open
        unless @device.open?
          puts "Opening #{short_s}"
          @device.open
          Device.open_devices << self
        end
      end   
      
      def close
        if @device.open?
          puts "Closing #{device.short_s}"          
          @device.close
          Device.open_devices.delete(self)
        end
      end       

      def method_missing(sym, *args, &block)
        if @device.respond_to? sym
          @device.send(sym, *args, &block)
        else
          info.send(sym, *args, &block)
        end
      end 

      def >>(receiver)
        if receiver.kind_of? Device
          receiver.open     
          receiver = receiver.receiver
        end
        self.open
        @device.transmitter.receiver = receiver
      end   

      def [](field)
        send field
      end

      def to_s(indent='')
        fields = []
        fields << "#{indent}  type: '#{type}'"
        fields << "#{indent}  description: '#{escape info.description}'" if info.description !~ unknown?
        fields << "#{indent}  name: '#{escape info.name}'" if info.name !~ unknown?
        fields << "#{indent}  vendor: '#{escape info.vendor}'" if info.vendor !~ unknown?
        fields << "#{indent}  version: '#{escape info.version}'" if info.version !~ unknown?      
        "#{indent}{\n" + fields.join(",\n") + "\n#{indent}}"
      end 
      
      # A more compact String representation that should uniquely identify the device to a human.
      def short_s
        "MIDI #{type} device: #{info.description}"
      end
      
    end
    
  end
  
end