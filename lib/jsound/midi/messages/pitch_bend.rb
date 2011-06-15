module JSound
  module Midi
    module Messages

      class PitchBend < Message

        attr_reader :value

        def initialize(value, channel=0, options={})
          super(nil, channel, options)
          self.value = value # we set #data as a side-effect here
        end

        # @param value [Fixnum] an 14-bit int in the range 0-16383 (8192 is no bend)
        def value= value
          @value = value
          self.data = DataConversion.to_7bit(value)
        end

        # @param f [Float] in the range -1.0 to 1.0
        def self.from_f(f, channel=0, options={})
          new DataConversion.normalized_float_to_14bit(f), channel=0, options
        end

        def self.from_java(java_message, options={})
          value = DataConversion.from_7bit(java_message.data1, java_message.data2)
          new value, java_message.channel, options.merge({:java_message => java_message})
        end
      end

    end
  end      
end