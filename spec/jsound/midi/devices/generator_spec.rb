require 'spec_helper'

module JSound::Midi::Devices
  describe Generator do

    let(:generator) { Generator.new }
    let(:output) { mock('device') }
    before { generator >> output }

    it "should generate note_on messages" do
      output.should_receive(:message).once.with note_on_message(0)
      generator.note_on(0)
    end

    it "should generate note_off messages" do
      output.should_receive(:message).once.with note_off_message(0)
      generator.note_off(0)
    end

  end
end
