require 'spec_helper'

module JSound::Midi::Devices
  describe OutputDevice do

    let(:device) { OutputDevice.new }
    let(:another_device) { mock 'device' }

    describe "#output=" do
      it "should raise an error, since outputs cannot have outputs assigned" do
        lambda{ device.output = another_device }.should raise_error
      end
    end

    describe "#>>" do
      it "should raise an error, since outputs cannot have outputs assigned" do
        lambda{ device >> another_device }.should raise_error
      end
    end

  end
end
