module JSound::Midi

  # Helper methods for converting MIDI data values
  module DataConversion

    # The maximum value for unsigned 14-bit integer
    MAX_14BIT_VALUE = 16383  # == 127 + (127 << 7) 

    # Convert a single integer to a [least_significant, most_significant] pair of 7-bit ints
    def to_7bit(value)
      [value & 127, value >> 7]
    end

    # Convert a [least_significant, most_significant] pair of 7-bit ints to a single integer     
    def from_7bit(lsb, msb)
      lsb + (msb << 7)
    end

    # Scales a float from the range [-1.0, 1.0] to the integer range [0, 16383]
    def normalized_float_to_14bit(float)
      (MAX_14BIT_VALUE*(float+1)/2).round
    end

  end
end
