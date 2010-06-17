require 'spec_helper'

module JSound::Midi::Devices
  describe Generator do

    let(:generator) { Generator.new }
    let(:receiver) { mock('device') }
    before(:all) { generator >> receiver }

    it "should generate note_on messages" do
      receiver.should_receive(:<=).once.with note_on_message(0)
      generator.note_on(0)
    end

    it "should generate note_off messages" do
      receiver.should_receive(:<=).once.with note_off_message(0)
      generator.note_off(0)
    end
    
    it 'should have more comprehensive specs'
    
  end
end
