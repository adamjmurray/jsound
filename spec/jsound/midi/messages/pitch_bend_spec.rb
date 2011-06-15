require 'spec_helper'
module JSound::Midi::Messages

  describe PitchBend do

    let(:value) { 1000 }
    let(:lsb) { value & 127 }
    let(:msb) { (value >> 7) & 127 }
    let(:channel) { 4 }
    let(:pitch_bend) { PitchBend.new(value,channel) }

    describe ".from_java" do
      before do
        @java_message = javax.sound.midi.ShortMessage.new
        @java_message.setMessage(javax.sound.midi.ShortMessage::PITCH_BEND, channel, lsb, msb)
      end

      it "constructs a new instance from a javax.sound.midi.ShortMessage" do
        PitchBend.from_java(@java_message).should be_a PitchBend
      end

      it "extracts the 14-bit value from the 2 7-bit data bytes" do
        pitch_bend = PitchBend.from_java(@java_message)
        pitch_bend.value.should == value
      end

      it "extracts the channel" do
        PitchBend.from_java(@java_message).channel.should == channel
      end

      it "creates an equal object when called with itself's #to_java" do
        PitchBend.from_java(pitch_bend.to_java).should == pitch_bend
      end

      it "creates an object that returns the java message in response to #to_java" do
        PitchBend.from_java(@java_message).to_java.should be_equal @java_message
      end
    end

    describe "#to_java" do
      it "creates a javax.sound.midi.ShortMessage" do
        pitch_bend.to_java.should be_a javax.sound.midi.ShortMessage
      end

      it "creates a message with a PITCH_BEND command" do
        pitch_bend.to_java.command.should == javax.sound.midi.ShortMessage::PITCH_BEND
      end

      it "creates a message with the least significant 7-bits in the data1 byte" do
        pitch_bend.to_java.data1.should == lsb
      end

      it "creates a message with the most significant 7-bits in the data2 byte" do
        pitch_bend.to_java.data2.should == msb
      end

      it "creates a message with the given channel" do
        pitch_bend.to_java.channel.should == channel
      end
    end

    describe "#value" do
      it "is the value of the message" do
        pitch_bend.value.should == value
      end

      it "is the 14-bit value of the message" do
        pitch_bend.value.should == lsb + (msb << 7)
      end
    end

    describe "#value=" do
      it "sets the value" do
        pitch_bend.value = 2000
        pitch_bend.value.should == 2000
      end

      it "affects the java message" do
        pitch_bend.value = 2000
        java_message = pitch_bend.to_java
        java_message.data1.should == 2000 & 127
        java_message.data2.should == (2000 >> 7) & 127
      end

    end

  end
end