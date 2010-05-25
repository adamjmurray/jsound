module JSound
  module Midi
    module Messages
      
      class PitchBend < Message
        
        include DataConversion
        
        attr_reader :value
        
        def initialize(value, channel=0, java_message=nil)
          @data = @value = value
          @channel = channel
          @java_message = java_message
        end
        
        def self.from_java(java_message)
          value = from_7bit(java_message.data1, java_message.data2)     
          new(value, java_message.channel, java_message)
        end        
       
      end      
      
    end
  end
end