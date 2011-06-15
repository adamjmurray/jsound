require 'spec_helper'
module JSound::Midi::Messages

  describe NoteOff do

    let(:pitch) { 60 }
    let(:velocity) { 100 }
    let(:channel) { 3 }
    let(:note_off) { NoteOff.new(pitch,velocity,channel) }

    describe ".from_java" do
      before do
        @java_message = javax.sound.midi.ShortMessage.new
        @java_message.setMessage(javax.sound.midi.ShortMessage::NOTE_OFF, channel, pitch, velocity)
      end

      it "constructs a new instance from a javax.sound.midi.ShortMessage" do
        NoteOff.from_java(@java_message).should be_a NoteOff
      end

      it "extracts the pitch from the data1 byte" do
        NoteOff.from_java(@java_message).pitch.should == pitch
      end

      it "extracts the velocity from the data2 byte" do
        NoteOff.from_java(@java_message).velocity.should == velocity
      end

      it "extracts the channel" do
        NoteOff.from_java(@java_message).channel.should == channel
      end

      it "creates an equal object when called with itself's #to_java" do
        NoteOff.from_java(note_off.to_java).should == note_off
      end
    end

    describe "#to_java" do
      it "creates a javax.sound.midi.ShortMessage" do
        note_off.to_java.should be_a javax.sound.midi.ShortMessage
      end

      it "creates a message with a note_off command" do
        note_off.to_java.command.should == javax.sound.midi.ShortMessage::NOTE_OFF
      end

      it "creates a message with pitch in the data1 byte" do
        note_off.to_java.data1.should == pitch
      end

      it "creates a message with velocity in the data2 byte" do
        note_off.to_java.data2.should == velocity
      end

      it "creates a message with the given channel" do
        note_off.to_java.channel.should == channel
      end
    end


  end
end