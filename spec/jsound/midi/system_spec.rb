require 'spec_helper'

module JSound
  describe Midi do

    # The spec doesn't care what MIDI devices are found, 
    # but it better find something or this library is not useful.     

    it 'should have DEVICES' do
      Midi::DEVICES.should_not be_empty  
    end

    it 'should have some INPUTS or OUTPUTS' do
      (Midi::INPUTS.length + Midi::OUTPUTS.length).should > 1
    end 

    context 'with Midi included' do
      include Midi
      describe '#refresh_devices' do
        it 'should refresh the list of midi devices' do
          Midi::DEVICES.clear
          refresh_devices
          Midi::DEVICES.should_not be_empty
        end
      end
    end

    it 'should expose #refresh_devices as a module function' do
      Midi.refresh_devices
    end

  end
end
