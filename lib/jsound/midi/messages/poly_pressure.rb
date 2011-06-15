module JSound::Midi::Messages      
  class PolyPressure < Message

    def initialize(pitch, pressure, channel=0, options={})
      super([pitch,pressure], channel, options)
    end

    alias pitch data1
    alias pitch= data1=

    alias pressure data2
    alias pressure= data2=

    def self.from_java(java_message, options={})
      new java_message.data1, java_message.data2, java_message.channel, options.merge({:java_message => java_message})
    end        

  end      
end