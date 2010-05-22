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

    ##############################################
    
    MidiSystem.getMidiDeviceInfo.each do |device_info| 
      device = MidiSystem.getMidiDevice(device_info)
      wrapped_device = Device.new(device)
      case device
      when Sequencer then SEQUENCERS << wrapped_device
      when Synthesizer then SYNTHS << wrapped_device
      else
        if device.getMaxTransmitters != 0 then INPUTS << wrapped_device end
        if device.getMaxReceivers != 0 then OUTPUTS << wrapped_device end
      end 
      DEVICES << wrapped_device    
    end

  end
end