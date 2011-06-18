require 'spec_helper'

module JSound::Midi

  describe DeviceList do

    let(:device1) { mock('device1', :description => 'Mock Device #1') }
    let(:device2) { mock('device2', :description => 'Mock Device #2') }
    let(:device3) { mock('device3', :description => 'Mock Device #3') }
    let(:devices) { [device1,device2,device3] }
    let(:device_list) { DeviceList.new devices }

    describe '.new' do
      it "constructs an empty device list with no arguments" do
        DeviceList.new.should be_empty
      end

      it "constructs a list with the given arguments" do
        DeviceList.new(devices).devices.should == devices
      end
    end

    describe "#each" do
      it "yields each device" do
        yielded = []
        device_list.each{|device| yielded << device }
        yielded.should == devices
      end
    end

    describe "#open" do
      it "acts like #find and also opens the device" do
        device2.should_receive :open
        device_list.open(/Mock.*2/).should == device2
      end

      it "raises an error when no device is not found" do
        lambda{ device_list.open(:nothing) }.should raise_error
      end
    end

    describe "#/" do
      it "finds and opens the first device matching a regexp constructed from the argument" do
        device1.should_receive(:open)
        (device_list/'Mock').should == device1
      end

      it "is case insensitive" do
        device1.should_receive(:open)
        (device_list/'mock').should == device1
      end
    end

    describe "#output=" do
      it "passes the argument to each device#open" do
        output = mock "output"
        device1.should_receive(:output=).with output
        device2.should_receive(:output=).with output
        device3.should_receive(:output=).with output
        device_list.output = output
      end
    end

    describe "#>>=" do
      it "acts like #output=" do
        output = mock "output"
        device1.should_receive(:output=).with output
        device2.should_receive(:output=).with output
        device3.should_receive(:output=).with output
        device_list >> output
      end
    end

    describe "#method_missing" do
      it "acts like #/ for unimplemented methods" do
        device1.should_receive(:open)
        device_list.mock.should == device1
      end

      it "treats '_' like a wildard" do
        device2.should_receive(:open)
        device_list.mock_2.should == device2
      end

    end

  end
end