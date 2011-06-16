require 'spec_helper'
module JSound::Midi
  module Devices

    describe Transformer do

      describe "#message" do
        it "transform the messages using the block passed to .new" do
          transformer = Transformer.new{|message| message.pitch += 12; message }
          output = mock 'device'
          transformer >> output
          output.should_receive(:message).once.with MessageBuilder.note_on(72,100)
          transformer.message MessageBuilder.note_on(60,100)
        end
      end

    end

  end
end
