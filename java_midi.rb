require 'java'

module JavaMidi
  include_package 'javax.sound.midi'
  
  class MidiDevice
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
      if receiver.is_a? MidiDevice
        receiver.open if not receiver.open?     
        receiver = receiver.receiver
      end
      @device.open if not @device.open?    
      @device.transmitter.receiver = receiver
    end   
    
    def [](field)
      send field
    end

    def to_s
      fields = []
      fields << "  description: '#{escape info.description}'" if info.description !~ unknown?
      fields << "  name: '#{escape info.name}'" if info.name !~ unknown?
      fields << "  vendor: '#{escape info.vendor}'" if info.vendor !~ unknown?
      fields << "  version: '#{escape info.version}'" if info.version !~ unknown?      
      "{\n" + fields.join(",\n") + "\n}"
    end    
  end
  
  
  class MidiDeviceCollection
    
    def initialize
      @coll = []
    end  

    def list(field=:description)
      @coll.collect{|device| device[field]}.delete_if{|value| value =~ JavaMidi::unknown? }
    end

    def find(criteria)
      search :find, criteria
    end
    
    def find_all(criteria)
      search :find_all, criteria
    end
    
    def [](criteria)
      if criteria.kind_of? Fixnum or criteria.kind_of? Range
        @coll[criteria]
      else
        find_all(criteria)
      end
    end
    
    def /(regexp)
      regexp = Regexp.new(regexp.to_s) if not regexp.kind_of? Regexp
      find(regexp)
    end
    
    def to_s
      @coll.join("\n")
    end
    
    private
    
    def search(iterator, criteria)
      field, target_value = field_and_target_value_for(criteria)
      matcher = matcher_for(target_value)
      @coll.send(iterator) do |device|        
        device[field].send(matcher, target_value)
      end
    end
    
    def field_and_target_value_for(criteria)
      if criteria.respond_to? :[] and criteria.respond_to? :keys
        first_key = criteria.keys.first
        return first_key, criteria[first_key]
      else
        return :description, criteria
      end
    end
      
    def matcher_for(target_value)
      case target_value
      when Regexp then '=~'
      else '=='
      end
    end
    
    def method_missing(sym, *args, &block)
      @coll.send(sym, *args, &block)
    end      
  end
  
  private
  devices = MidiSystem.getMidiDeviceInfo.map do |device_info| 
    MidiSystem.getMidiDevice(device_info)
  end
  
  public
  MIDI_DEVICES = MidiDeviceCollection.new
  MIDI_SYNTHS = MIDI_SYNTHESIZERS = MidiDeviceCollection.new
  MIDI_SEQUENCERS = MidiDeviceCollection.new
  MIDI_INPUTS = MidiDeviceCollection.new
  MIDI_OUTPUTS = MidiDeviceCollection.new
  
 for device in devices
    wrapped_device = MidiDevice.new(device)
    case device
    when Sequencer then MIDI_SEQUENCERS << wrapped_device
    when Synthesizer then MIDI_SYNTHS << wrapped_device
    else
      if device.getMaxTransmitters != 0 then MIDI_INPUTS << wrapped_device end
      if device.getMaxReceivers != 0 then MIDI_OUTPUTS << wrapped_device end
    end 
    MIDI_DEVICES << wrapped_device    
  end
  
  def unknown?
    # I'm not sure if this pattern should change based on locale.
    # It seems stupid that java midi device info would always returns an "Unknown _____" string 
    # when it doesn't have a value for the field, so I guess this probably won't work in a non-English locale...
    # Why doesn't it just return nil? 
    /^Unknown/
  end
  
  def escape(s)
    s.gsub("'","\\\\'")
  end
  
end