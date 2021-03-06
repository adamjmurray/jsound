module JSound
  module Midi
    module Messages

      class ChannelPressure < Message

        def initialize(pressure, channel=0, options={})
          super([pressure, 0], channel, options)
        end

        alias pressure data1
        alias pressure= data1=

        def self.from_java(java_message, options={})
          new java_message.data1, java_message.channel, options.merge({:java_message => java_message})
        end

        def clone
          self.class.new(pressure,@channel)
        end

      end

    end
  end
end