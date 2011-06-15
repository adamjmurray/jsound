require 'spec_helper'

module JSound::Midi
  describe MessageBuilder do

    it 'should expose its methods as module functions' do
      msg = MessageBuilder.note_on(60)
      msg.type.should == :note_on    
    end

    context 'with MessageBuilder included' do
      include MessageBuilder

      it 'should provide a set of methods for building midi messages' do
        msg = note_on(60)
        msg.type.should == :note_on
      end

    end

  end
end