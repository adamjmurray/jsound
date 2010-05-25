module JSound
  module Midi
    module Messages
      
      class ControlChange < Message
        
        attr_reader :control, :value
        
        def initialize(control, value, channel=0, java_message=nil)
          @control = control
          @value = value
          @data = {:control => control, :value => value}
          @channel = channel
          @java_message = java_message
        end
        
        def self.from_java(java_message)          
          new(java_message.data1, java_message.data2, java_message.channel, java_message)
        end        
       
      end      
      
    end
  end
end