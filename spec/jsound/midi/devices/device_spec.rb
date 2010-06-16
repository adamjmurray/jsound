#!/usr/bin/env jruby -S spec --format nested
require File.dirname(__FILE__)+'/../../../spec_helper'

include JSound::Midi::Devices

describe Device do
  let(:device)   { device = Device.new }
  let(:receiver) { mock('receiver') }
  
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
  
end
