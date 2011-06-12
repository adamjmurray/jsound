module JSound

  # Core interface for accessing MIDI devices
  module Midi
    include_package 'javax.sound.midi'
    include Devices

    # All MIDI devices
    DEVICES = DeviceList.new

    # MIDI input devices
    INPUTS = DeviceList.new

    # MIDI output devices
    OUTPUTS = DeviceList.new

    # MIDI synthesizer devices
    SYNTHESIZERS = SYNTHS = DeviceList.new

    # MIDI sequencer devices
    SEQUENCERS = DeviceList.new

    # Refresh the list of connected devices.
    def refresh_devices
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
    module_function :refresh_devices

    # Refresh devices automatically when loaded:
    refresh_devices()  

  end
end