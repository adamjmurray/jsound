#!/usr/bin/env jruby -S spec --format nested
require File.dirname(__FILE__)+'/../../../spec_helper'

include JSound::Midi::Messages

describe JSound::Midi::Messages::Builder do
  
  class BuilderWrapper
    include Builder
  end
  
  before(:all) do
    @builder = BuilderWrapper.new
  end
  
  it 'should expose its methods as module functions' do
    msg = Builder.note_on(60)
    msg.type.should == :note_on    
  end
  
  context 'with Builder included' do
    include Builder
    
    it 'should provide a set of methods for building midi messages' do
      msg = note_on(60)
      msg.type.should == :note_on
    end
    
  end
  
  it 'should have a spec that tests all its features'
    
end