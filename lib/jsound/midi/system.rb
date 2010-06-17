module JSound

  # Core interface for accessing midi devices
  module Midi
    include_package 'javax.sound.midi'
    include Devices

    # All devices
    DEVICES = DeviceCollection.new

    # Devices by type:
    INPUTS = DeviceCollection.new

    OUTPUTS = DeviceCollection.new

    SYNTHESIZERS = SYNTHS = DeviceCollection.new

    SEQUENCERS = DeviceCollection.new

    # Refresh the list of connected devices.
    # This happens automatically when the class is loaded.
    # You can call it again if you attach a new device during program execution.
    def self.refresh_devices
      [DEVICES,INPUTS,OUTPUTS,SYNTHESIZERS,SEQUENCERS].each{|collection| collection.clear}
      MidiSystem.getMidiDeviceInfo.each do |device_info| 
        java_device = MidiSystem.getMidiDevice(device_info)
        device = JDevice.new(java_device)
        case device.type
        when :sequencer   then SEQUENCERS   << device
        when :synthesizer then SYNTHESIZERS << device
        when :input       then INPUTS       << device
        when :output      then OUTPUTS      << device
        end 
        DEVICES << device    
      end
      return DEVICES
    end
    refresh_devices()  

    # You can use this method directly if you include this module
    def refresh_midi_devices
      JSound::Midi.refresh_devices
    end

  end
end