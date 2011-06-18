require 'spec_helper'

module JSound::Midi::Devices
  describe Recorder do
    let(:recorder) { Recorder.new }

    context 'initial state' do
      it 'should be recording by default' do
        recorder <= :message
        recorder.messages.should == [:message]
      end

      it 'should not record anything when the constructor argument is false' do
        recorder = Recorder.new(false)
        recorder <= :message
        recorder.messages.should be_empty
      end
    end

    describe '#start' do
      it 'should start recording' do
        recorder.start
        recorder <= :message
        recorder.messages.should == [:message]
      end
    end

    describe '#messages' do
      it 'should return all recorded messages in an Array' do
        recorder.start
        recorder <= :one
        recorder <= 2
        recorder <= 'three'
        recorder.messages.should == [:one, 2, 'three']
      end
    end

    describe '#messages_with_timestamps' do
      it 'should return all recorded [message,timestamp] pairs in an Array' do
        recorder.start
        time = Time.now.to_i
        recorder <= :one
        recorder <= 2
        recorder <= 'three'
        # assuming this test all happens within a small fraction of a second:
        recorder.messages_with_timestamps.should == [[:one,time], [2,time], ['three',time]]
      end
    end

    describe '#stop' do
      it 'should stop recording' do
        recorder.start
        recorder <= :message_while_started        
        recorder.stop      
        recorder <= :message_while_stopped
        recorder.messages.should == [:message_while_started]      
      end
    end

    describe '#clear' do
      it 'should clear the recorded messages' do
        recorder.start
        recorder <= :message
        recorder.clear
        recorder.messages.should be_empty
      end
    end

    describe '#recording?' do
      it 'should be true in the initial state' do
        recorder.recording?.should be_true
      end
      it 'should be false in the initial state when given a false constructor argument' do
        Recorder.new(false).recording?.should be_false
      end
      it 'should be true after #start' do
        recorder.start
        recorder.recording?.should be_true
      end
      it 'should be false after #end' do
        recorder.start
        recorder.stop
        recorder.recording?.should be_false
      end
    end

    describe "#output=" do
      it "should raise an error, since outputs cannot have outputs assigned" do
        lambda{ recorder.output = Device.new }.should raise_error
      end
    end

    describe "#>>" do
      it "should raise an error, since outputs cannot have outputs assigned" do
        lambda{ device >> Device.new }.should raise_error
      end
    end

  end
end
