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
    
    def >(output)
      if output.is_a? MidiDevice
        output = output.getReceiver
      end
      @device.getTransmitter.setReceiver(output)  
    end   
    
    def [](field)
      self.send field
    end

    def to_s
      json = "{\n"
      json += "  description: '#{escape info.description}'\n" if info.description !~ unknown
      json += "  name: '#{escape info.name}'\n" if info.name !~ unknown
      json += "  vendor: '#{escape info.vendor}'\n" if info.vendor !~ unknown
      json += "  version: '#{escape info.version}'\n" if info.version !~ unknown
      json += "}"
    end
    
    private
    def unknown
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
  
  
  class MidiDeviceCollection < Array   

    def find_device(with_descriptor, field=:description)
      search :find, field, with_descriptor
    end
    
    def find_all_devices(with_descriptor, field=:description)
      search :find_all, field, with_descriptor
    end
    
    def open(with_descriptor, field=:description)
      device = find_device(with_descriptor, field)
      device.open
      return device
    end
    
    private
    def search(iterator, field, descriptor)
      matcher = matcher_for(descriptor)
      send(iterator) do |device|
        device[field].send(matcher, descriptor)
      end
    end
      
    def matcher_for descriptor
      case descriptor
      when Regexp then '=~'
      else '=='
      end
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
  
end