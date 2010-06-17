#!/usr/bin/env jruby -S spec --format nested --color
require File.dirname(__FILE__)+'/../../../spec_helper'

module JSound::Midi::Devices
  describe Recorder do

    before(:each) do
      @recorder = Recorder.new
    end

    context 'initial state' do
      it 'should not record anything' do
        @recorder <= :message
        @recorder.messages.should be_empty    
      end
    end

    context 'instance methods' do
      
      describe '#start' do
        it 'should start recording' do
          @recorder.start
          @recorder <= :message
          @recorder.messages.should == [:message]
        end
      end

      describe '#messages' do
        it 'should return all recorded messages in an Array' do
          @recorder.start
          @recorder <= :one
          @recorder <= 2
          @recorder <= 'three'
          @recorder.messages.should == [:one, 2, 'three']
        end
      end

      describe '#stop' do
        it 'should stop recording' do
          @recorder.start
          @recorder <= :message_while_started        
          @recorder.stop      
          @recorder <= :message_while_stopped
          @recorder.messages.should == [:message_while_started]      
        end
      end

      describe '#clear' do
        it 'should clear the recorded messages' do
          @recorder.start
          @recorder <= :message
          @recorder.clear
          @recorder.messages.should be_empty
        end
      end

      describe '#recording?' do
        it 'should be false in the initial state' do
          @recorder.recording?.should be_false
        end
        it 'should be true after #start' do
          @recorder.start
          @recorder.recording?.should be_true
        end
        it 'should be false after #end' do
          @recorder.start
          @recorder.stop
          @recorder.recording?.should be_false
        end
      end
      
    end

  end
end
