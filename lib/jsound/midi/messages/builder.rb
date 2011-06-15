module JSound::Midi::Messages

  # A collection of methods for building MIDI messages.
  module Builder

    def note_on(pitch, velocity=127, channel=0)
      NoteOn.new(pitch,velocity,channel)
    end
    
    def note_off(pitch, velocity=127, channel=0)
      NoteOff.new(pitch,velocity,channel)
    end
    
    # Most methods in here take 7-bit ints for their args, but this one takes a 14-bit
    # The value can be an int in the range 0-16383 (8192 is no bend)
    # or it can be a float, which is assumed to be in the range -1.0 to 1.0
    def pitch_bend(value, channel=0)
      PitchBend.new(value, channel)
    end

    def control_change(control, value, channel=0)
      ControlChange.new(control, value, channel)
    end

    def channel_pressure(pressure, channel=0)
      ChannelPressure.new(pressure, channel)
    end
    alias channel_aftertouch channel_pressure

    def poly_pressure(pitch, pressure, channel=0)
      PolyPressure.new(pitch, pressure, channel)
    end
    alias poly_aftertouch poly_pressure

    def program_change(program, channel=0)
      ProgramChange.new(program, channel)
    end

    # Make all methods be module functions (accessible by sending the method name to module directly)
    instance_methods.each do |method|
      module_function method
    end

  end
end