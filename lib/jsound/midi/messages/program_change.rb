module JSound
  module Midi
    module Messages

      class ProgramChange < Message

        def initialize(program, channel=0, options={})
          super([program,0], channel, options)
          @program = program
        end

        alias program data1
        alias program= data1=

        def self.from_java(java_message, options={})
          new java_message.data1, java_message.channel, options.merge({:java_message => java_message})
        end

        def clone
          self.class.new(program,@channel)
        end

      end

    end
  end
end