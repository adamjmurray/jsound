require 'jsound/midi/message'
require 'jsound/midi/messages/channel_pressure'
require 'jsound/midi/messages/control_change'
require 'jsound/midi/messages/note_on'
require 'jsound/midi/messages/note_off'
require 'jsound/midi/messages/pitch_bend'
require 'jsound/midi/messages/poly_pressure'
require 'jsound/midi/messages/program_change'

require 'jsound/midi/message_builder'

require 'jsound/midi/device'
require 'jsound/midi/devices/generator'
require 'jsound/midi/devices/jdevice'
require 'jsound/midi/devices/input_device'
require 'jsound/midi/devices/output_device'
require 'jsound/midi/devices/monitor'
require 'jsound/midi/devices/recorder'
require 'jsound/midi/devices/repeater'
require 'jsound/midi/devices/transformer'

require 'jsound/midi/device_list'


module JSound

  # Module containing all MIDI functionality.
  #
  # Also provies the core interface for accessing MIDI devices, see the device list constants defined here.
  #
  module Midi
    include_package 'javax.sound.midi'

    # All MIDI devices
    # @return [DeviceList]
    DEVICES = DeviceList.new

    # MIDI input devices
    # @return [DeviceList] a list of {Devices::InputDevice}s
    INPUTS = DeviceList.new

    # MIDI output devices
    # @return [DeviceList] a list of {Devices::OutputDevice}s
    OUTPUTS = DeviceList.new

    # MIDI synthesizer devices
    # @return [DeviceList]
    SYNTHESIZERS = SYNTHS = DeviceList.new

    # MIDI sequencer devices
    # @return [DeviceList]
    SEQUENCERS = DeviceList.new

    # Refresh the list of connected devices.
    # @note this happens automatically when JSound is required.
    def refresh_devices
      [DEVICES,INPUTS,OUTPUTS,SYNTHESIZERS,SEQUENCERS].each{|collection| collection.clear}
      MidiSystem.getMidiDeviceInfo.each do |device_info| 
        java_device = MidiSystem.getMidiDevice(device_info)
        device = Devices::JDevice.from_java(java_device)
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