#!/usr/bin/env jruby -S spec --format nested --color
require File.dirname(__FILE__)+'/../../../spec_helper'

module JSound::Midi::Devices
  describe Recorder do

    before(:each) do
      @subject = Recorder.new
    end
    
    context 'initial state' do
      it 'should not record anything' do
        @subject <= :message
        @subject.messages.should be_empty    
      end
    end
  
    context '#start' do
      it 'should start recording' do
        @subject.start
        @subject <= :message
        @subject.messages.should == [:message]
      end
    end
    
    context '#messages' do
      it 'should store multiple messages in an Array' do
        @subject.start
        @subject <= :one
        @subject <= 2
        @subject <= 'three'
        @subject.messages.should == [:one, 2, 'three']
      end
    end
    
    context '#stop' do
      it 'should stop recording' do
        @subject.start
        @subject <= :message_while_started        
        @subject.stop      
        @subject <= :message_while_stopped
        @subject.messages.should == [:message_while_started]      
      end
    end
    
    context '#clear' do
      it 'should clear the recorded messages' do
        @subject.start
        @subject <= :message
        @subject.clear
        @subject.messages.should be_empty
      end
    end
    
    context '#recording?' do
      it 'should be false in the initial state' do
        @subject.recording?.should be_false
      end
      it 'should be true after #start' do
        @subject.start
        @subject.recording?.should be_true
      end
      it 'should be false after #end' do
        @subject.start
        @subject.stop
        @subject.recording?.should be_false
      end
    end
    
  end
end
