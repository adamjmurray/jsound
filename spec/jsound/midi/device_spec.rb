require 'spec_helper'

module JSound::Midi

  describe Device do
    let(:device)   { Device.new }
    let(:receiver) { mock('device') }

    describe '#open' do
      it "does nothing" do
        # just checking that device implements the method
        device.open
      end
    end

    describe '#open?' do
      it "is true, because the abstract Device is always open" do
        device.open?.should be_true
      end
    end

    describe '#close' do
      it "does nothing" do
        # just checking that device implements the method
        device.close
      end
    end

    describe "#type" do
      it "is :pass_through" do
        device.type.should == :pass_through
      end
    end

    describe '#receiver' do
      it "is the receiver of this device's messages" do
        device.receiver = receiver
        device.receiver.should == receiver
      end
    end

    describe '#>>' do
      it 'should connect to a receiver' do
        device >> receiver
        device.receiver.should == receiver
      end
    end

    describe '#message' do
      it 'should send messages to the connected receiver' do
        device >> receiver
        receiver.should_receive(:message).with('the_message')
        device.message 'the_message'
      end
    end

    describe '#<=' do
      it 'should behave like #send_message' do
        device >> receiver
        receiver.should_receive(:message).with('the_message')
        device <= 'the_message'
      end
    end

    it 'should pass through messages by default' do
      pass_through = Device.new
      device >> pass_through >> receiver 
      device.receiver.should == pass_through
      pass_through.receiver.should == receiver   
      receiver.should_receive(:message).with('message')
      device <= 'message'      
    end

  end
end