# Core system for accessing midi devices

module JSound

  module Midi
    include_package 'javax.sound.midi'
    
    # All devices
    DEVICES = DeviceCollection.new
  
    # Devices by type:
    INPUTS = DeviceCollection.new

    OUTPUTS = DeviceCollection.new

    SYNTHS = DeviceCollection.new

    SEQUENCERS = DeviceCollection.new

    # Rebuild the list of connected devices.
    # This happens automatically when the class is loaded.
    # You can explicitly call it again if you attach a new device during program execution.
    def self.load_devices
      [DEVICES,INPUTS,OUTPUTS,SYNTHS,SEQUENCERS].each{|collection| collection.clear}
      MidiSystem.getMidiDeviceInfo.each do |device_info| 
        java_device = MidiSystem.getMidiDevice(device_info)
        device = Device.new(java_device)
        case device.type
        when :sequencer then SEQUENCERS << device
        when :synth     then SYNTHS     << device
        when :input     then INPUTS     << device
        when :output    then OUTPUTS    << device
        end 
        DEVICES << device    
      end
    end
    load_devices()  
    
    # Access the load_devices method directly when including this module
    def load_devices
      Midi.load_devices
    end
    
  end
end