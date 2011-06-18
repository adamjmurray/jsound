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

        it "modifies message properties based on the Hash of mappings passed to .new" do
          transformer = Transformer.new({
            :attr1 => lambda{|attr| attr+1 },
            :attr2 => lambda{|attr| attr-1 },
          })
          message = mock 'message'
          message.stub!(:attr1).and_return 1
          message.stub!(:attr2).and_return 5

          message.should_receive(:attr1=).once.with 2
          message.should_receive(:attr2=).once.with 4
          transformer.message message
        end

        it "automatically clones the message when constructed with a Hash of mappings" do
          transformer = Transformer.new({ :attr1 => lambda{|attr| attr+1 } })
          message = mock 'message'
          message.should_receive :clone
          transformer.message message
        end

        it "does not clone the message when constructed with a Hash of mappings that includes {:clone => false}" do
          transformer = Transformer.new({ :attr1 => lambda{|attr| attr+1 }, :clone => false })
          message = mock 'message'
          message.should_not_receive :clone
          transformer.message message
        end

      end

    end

  end
end
