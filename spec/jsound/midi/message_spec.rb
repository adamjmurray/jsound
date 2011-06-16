require 'spec_helper'

module JSound::Midi

  describe Message do

    let(:data) { [50,100]}
    let(:channel) { 5 }
    let(:message) { Message.new(data, channel) }

    describe "#clone" do
      it "constructs a new Message" do
        message.clone.should_not be_equal message
      end

      it "constructs an equivalent Message" do
        message.clone.should == message
      end

      it "constructs a new Message with the same data" do
        message.clone.data.should == data
      end

      it "constructs a new Message with the same channel" do
        message.clone.channel.should == channel
      end
    end

  end
end