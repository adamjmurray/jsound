require 'jsound/midi/message'
require 'jsound/midi/messages/channel_pressure'
require 'jsound/midi/messages/control_change'
require 'jsound/midi/messages/note_on'
require 'jsound/midi/messages/note_off'
require 'jsound/midi/messages/pitch_bend'
require 'jsound/midi/messages/poly_pressure'
require 'jsound/midi/messages/program_change'

require 'jsound/midi/device_list'
require 'jsound/midi/message_builder'

require 'jsound/midi/device'
require 'jsound/midi/devices/bridge'
require 'jsound/midi/devices/generator'
require 'jsound/midi/devices/jdevice'
require 'jsound/midi/devices/monitor'
require 'jsound/midi/devices/recorder'


module JSound

  # Core interface for accessing MIDI devices
  module Midi
    include_package 'javax.sound.midi'

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
        device = Devices::JDevice.new(java_device)
        case device.type
        when :sequencer   then SEQUENCERS   << device
        when :synthesizer then SYNTHESIZERS << device
        when :input       then INPUTS       << device
        when :output      then OUTPUTS      << device
        end 
        DEVICES << device    
      end
      DEVICES
    end    
    module_function :refresh_devices

    # Refresh devices automatically when loaded:
    refresh_devices()  

  end
end