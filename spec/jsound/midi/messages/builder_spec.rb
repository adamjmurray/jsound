require 'spec_helper'

module JSound::Midi::Messages
  describe Builder do

    it 'should expose its methods as module functions' do
      msg = Builder.note_on(60)
      msg.type.should == :note_on    
    end

    context 'with Builder included' do
      include Builder

      it 'should provide a set of methods for building midi messages' do
        msg = note_on(60)
        msg.type.should == :note_on
      end

    end

  end
end