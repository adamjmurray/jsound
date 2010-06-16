#!/usr/bin/env jruby -S spec --format nested
require File.dirname(__FILE__)+'/../../spec_helper'

include JSound::Midi

describe JSound::Midi do
  
  it 'should find devices' do
    # We don't care what it finds, but if it can't find something, then this library is not useful:      
    DEVICES.length.should > 0    
  end
  
  context '#refresh_midi_devices' do
    it 'should refresh the list of midi devices' do
      DEVICES.clear
      refresh_midi_devices
      DEVICES.length.should > 0
    end
  end
end