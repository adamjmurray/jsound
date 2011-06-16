require 'spec_helper'

module JSound::Midi::Devices
  describe Repeater do

    let(:repeater) { Repeater.new }
    let(:output1) { mock 'device1' }
    let(:output2) { mock 'device1' }

    before { repeater >> [output1, output2] }

    it "should pass all messages to its outputs" do
      output1.should_receive(:message).once.with :the_message
      output2.should_receive(:message).once.with :the_message
      repeater.message :the_message
    end

  end
end
