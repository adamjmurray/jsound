require 'spec_helper'

module JSound::Midi

  describe Device do
    let(:device)   { Device.new }
    let(:output) { mock('device') }

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

    describe '#output' do
      it "is the output of this device's messages" do
        device.output = output
        device.output.should == output
      end
    end

    describe '#>>' do
      it 'should connect to a output' do
        device >> output
        device.output.should == output
      end
    end

    describe '#message' do
      it 'should send messages to the connected output' do
        device >> output
        output.should_receive(:message).with('the_message')
        device.message 'the_message'
      end
    end

    describe '#<=' do
      it 'should behave like #send_message' do
        device >> output
        output.should_receive(:message).with('the_message')
        device <= 'the_message'
      end
    end

    it 'should pass through messages by default' do
      pass_through = Device.new
      device >> pass_through >> output 
      device.output.should == pass_through
      pass_through.output.should == output   
      output.should_receive(:message).with('message')
      device <= 'message'      
    end

  end
end