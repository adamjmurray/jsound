require 'spec_helper'
module JSound::Midi::Messages

  describe NoteOn do

    let(:pitch) { 60 }
    let(:velocity) { 100 }
    let(:channel) { 3 }
    let(:note_on) { NoteOn.new(pitch,velocity,channel) }

    describe ".from_java" do
      before do
        @java_message = javax.sound.midi.ShortMessage.new
        @java_message.setMessage(javax.sound.midi.ShortMessage::NOTE_ON, channel, pitch, velocity)
      end

      it "constructs a new instance from a javax.sound.midi.ShortMessage" do
        NoteOn.from_java(@java_message).should be_a NoteOn
      end

      it "extracts the pitch from the data1 byte" do
        NoteOn.from_java(@java_message).pitch.should == pitch
      end

      it "extracts the velocity from the data2 byte" do
        NoteOn.from_java(@java_message).velocity.should == velocity
      end

      it "extracts the channel" do
        NoteOn.from_java(@java_message).channel.should == channel
      end

      it "creates an equal object when called with itself's #to_java" do
        NoteOn.from_java(note_on.to_java).should == note_on
      end
    end

    describe "#to_java" do
      it "creates a javax.sound.midi.ShortMessage" do
        note_on.to_java.should be_a javax.sound.midi.ShortMessage
      end

      it "creates a message with a NOTE_ON command" do
        note_on.to_java.command.should == javax.sound.midi.ShortMessage::NOTE_ON
      end

      it "creates a message with pitch in the data1 byte" do
        note_on.to_java.data1.should == pitch
      end

      it "creates a message with velocity in the data2 byte" do
        note_on.to_java.data2.should == velocity
      end

      it "creates a message with the given channel" do
        note_on.to_java.channel.should == channel
      end
    end

    describe "#pitch" do
      it "is the pitch of the message" do
        note_on.pitch.should == pitch
      end

      it "is the first data byte" do
        note_on.pitch.should == note_on.data[0]
      end
    end

    describe "#pitch=" do
      it "sets the pitch of the message" do
        pitch2 = pitch+1
        note_on.pitch = pitch2
        note_on.pitch.should == pitch2
      end

      it "causes the java_message (returned from #to_java) to be regenereated" do
        pitch2 = pitch+1
        note_on.pitch = pitch2
        note_on.to_java.data1.should == pitch2
      end
    end

    describe "#velocity" do
      it "is the velocity of the message" do
        note_on.velocity.should == velocity
      end

      it "is the second data byte" do
        note_on.velocity.should == note_on.data[1]
      end
    end

    describe "#velocity=" do
      it "sets the velocity of the message" do
        velocity2 = velocity+1
        note_on.velocity = velocity2
        note_on.velocity.should == velocity2
      end

      it "causes the java_message (returned from #to_java) to be regenereated" do
        velocity2 = velocity+1
        note_on.velocity = velocity2
        note_on.to_java.data2.should == velocity2
      end
    end

  end
end