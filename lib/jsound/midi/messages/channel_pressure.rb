module JSound::Midi::Messages
  class ChannelPressure < Message

    attr_reader :pressure

    def initialize(pressure, channel=0, java_message=nil)
      @data = @pressure = pressure
      @channel = channel
      @java_message = java_message
    end

    def self.from_java(java_message)
      new(java_message.data1, java_message.channel, java_message)
    end        

  end      
end