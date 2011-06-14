module JSound::Midi::Devices

  # A Java-provided MIDI device (wraps javax.sound.midi.MidiDevice objects)
  class JDevice < Device
    include_package 'javax.sound.midi'      
    include JSound::Util

    # the javax.sound.midi.MidiDevice.Info object for this java device
    attr_reader :info

    # the description of this device
    # @return [String]
    attr_reader :description
    
    def self.open_devices
      @@open_devices ||= []
    end
    at_exit do
      # Close all open devices so we don't hang the program at shutdown time
      for device in JDevice.open_devices
        device.close
      end
    end         

    def initialize(device)
      @device = device        
      @info = @device.deviceInfo
      @description = @info.description

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

      case @type
      when :input
        @bridge = Bridge.new(self)        
        @device.transmitter.receiver = @bridge
      when :output
        @receiver = @device.receiver
      end
    end

    def open
      unless @device.open?
        puts "Opening #{to_s}"
        @device.open
        JDevice.open_devices << self
      end
    end   

    def close
      if @device.open?
        puts "Closing #{to_s}"          
        @device.close
        JDevice.open_devices.delete(self)
      end
    end       

    def method_missing(sym, *args, &block)
      if @device.respond_to? sym
        @device.send(sym, *args, &block)
      else
        @info.send(sym, *args, &block)
      end
    end
    
    def respond_to?(sym)
      super or @device.respond_to? sym or info.respond_to? sym
    end

    def >>(device)
      super
      @bridge >> device if @bridge
      # else ??? For outputs I guess this should be an error
    end   

    def message(message)
      # unwrap the ruby message wrapper, if needed:
      message = message.java_message if message.respond_to? :java_message

      # Use java_send to call Receiver.send() since it conflicts with Ruby's built-in send method
      # -1 means no timestamp, so we're not supporting timestamps        
      @receiver.java_send(:send, [MidiMessage, Java::long], message, -1) if @receiver        
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

    def to_json(indent='')
      fields = []
      fields << "#{indent}  type: '#{type}'"
      fields << "#{indent}  description: '#{escape info.description}'" if info.description !~ unknown?
      fields << "#{indent}  name: '#{escape info.name}'" if info.name !~ unknown?
      fields << "#{indent}  vendor: '#{escape info.vendor}'" if info.vendor !~ unknown?
      fields << "#{indent}  version: '#{escape info.version}'" if info.version !~ unknown?      
      "#{indent}{\n" + fields.join(",\n") + "\n#{indent}}"
    end 

  end
end