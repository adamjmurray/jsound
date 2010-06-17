require 'spec_helper'

module JSound::Midi

  describe Device do
    let(:device)   { Device.new }
    let(:receiver) { mock('device') }

    describe '#>>' do
      it 'should connect to a receiver' do
        device >> receiver
        device.receiver.should == receiver
      end
    end

    describe '#<=' do
      it 'should send messages to the connected receiver' do
        device >> receiver
        receiver.should_receive(:<=).with('message')            
        device <= 'message'      
      end
    end

    it 'should pass through messages by default' do
      pass_through = Device.new
      device >> pass_through >> receiver 
      device.receiver.should == pass_through
      pass_through.receiver.should == receiver   
      receiver.should_receive(:<=).with('message')      
      device <= 'message'      
    end

    it 'should have more comprehensive specs'

  end
end