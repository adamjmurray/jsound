module JSound
  module Midi
    module Messages

      class NoteOn < Message

        def initialize(pitch, velocity=127, channel=0, options={})
          super([pitch,velocity], channel, options)
        end

        alias pitch data1
        alias pitch= data1=

        alias velocity data2
        alias velocity= data2=

        def self.from_java(java_message, options={})
          new java_message.data1, java_message.data2, java_message.channel, options.merge({:java_message => java_message})
        end

      end

    end
  end
end