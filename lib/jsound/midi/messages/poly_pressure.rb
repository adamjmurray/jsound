module JSound::Midi::Messages      
  class PolyPressure < Message

    attr_reader :pitch, :pressure

    def initialize(pitch, pressure, channel=0, java_message=nil)
      @pitch = pitch
      @pressure = pressure
      @data = {:pitch => pitch, :pressure => pressure}
      @channel = channel
      @java_message = java_message
    end

    def self.from_java(java_message)          
      new(java_message.data1, java_message.data2, java_message.channel, java_message)
    end        

  end      
end