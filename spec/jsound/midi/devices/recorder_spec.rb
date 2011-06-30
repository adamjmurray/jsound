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
        start_time = Time.now.to_f
        recorder <= :one
        recorder <= 2
        recorder <= 'three'
        mwt = recorder.messages_with_timestamps

        message1, time1 = *mwt[0]
        message2, time2 = *mwt[1]
        message3, time3 = *mwt[2]
        [message1, message2, message3].should == [:one, 2, 'three']
        time1.should be_a Float
        time1.should be_within(0.01).of start_time
        time2.should be_within(0.015).of start_time
        time3.should be_within(0.02).of start_time
        time1.should <= time2
        time2.should <= time3
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
