module JSound
  module Midi
    module Messages

      class ControlChange < Message

        def initialize(control, value, channel=0, options={})
          super([control,value], channel, options)
        end

        alias control data1
        alias control= data1=

        alias value data2
        alias value= data2=

        def self.from_java(java_message, options={})
          new java_message.data1, java_message.data2, java_message.channel, options.merge({:java_message => java_message})
        end

      end

    end
  end
end