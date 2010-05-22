# A single MIDI device
# Wraps javax.sound.midi.MidiDevice objects

module JSound
  
  module Midi
    
    class Device      
      include Util
      
      def initialize(device)
        @device = device
      end

      def info
        @device.deviceInfo
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
          receiver.open if not receiver.open?     
          receiver = receiver.receiver
        end
        @device.open if not @device.open?    
        @device.transmitter.receiver = receiver
      end   

      def [](field)
        send field
      end

      def to_s(indent='')
        fields = []
        fields << "#{indent}  description: '#{escape info.description}'" if info.description !~ unknown?
        fields << "#{indent}  name: '#{escape info.name}'" if info.name !~ unknown?
        fields << "#{indent}  vendor: '#{escape info.vendor}'" if info.vendor !~ unknown?
        fields << "#{indent}  version: '#{escape info.version}'" if info.version !~ unknown?      
        "#{indent}{\n" + fields.join(",\n") + "\n#{indent}}"
      end    
    end
    
  end
  
end