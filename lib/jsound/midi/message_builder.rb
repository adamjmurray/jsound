# An includeable module with convenient methods for building MIDI messages.

module JSound
  module Midi
    module MessageBuilder
      include_package 'javax.sound.midi'
      include DataConversion
      
      def note_on(pitch, velocity=127, channel=0)
        midi_command(ShortMessage::NOTE_ON, channel, pitch, velocity)
      end
      
      def note_off(pitch, velocity=0, channel=0)
        midi_command(ShortMessage::NOTE_OFF, channel, pitch, velocity)
      end
      
      # Most methods in here take 7-bit ints for their args, but this one takes a 14-bit
      # The value can be an int in the range 0-16383 (8192 is no bend)
      # or it can be a float, which is assumed to be in the range -1.0 to 1.0
      def pitch_bend(value, channel=0)
        value = normalized_float_to_14bit(value) if value.is_a? Float        
        lsb, msb = to_7bit(value)
        midi_command(ShortMessage::PITCH_BEND, channel, lsb, msb)
      end
      
      def control_change(control, value, channel=0)
        midi_command(ShortMessage::CONTROL_CHANGE, channel, control, value)
      end

      def channel_pressure(pressure, channel=0)
        midi_command(ShortMessage::CHANNEL_PRESSURE, channel, pressure)
      end
      alias channel_aftertouch channel_pressure
      
      def poly_pressure(note, pressure, channel=0)
        midi_command(ShortMessage::POLY_PRESSURE, channel, note, pressure)  
      end
      alias poly_aftertouch poly_pressure

      def program_change(program_number, channel=0)
        midi_command(ShortMessage::PROGRAM_CHANGE, channel, program_number)
      end
      
      # Build a Message object for MIDI commands, including
      # note on/off, control change, pitch bend, pressure, and program change
      def midi_command(type, channel, data1, data2=0)
        java_message = ShortMessage.new
        java_message.setMessage(type, channel, data1, data2)
        return Message.from_java(java_message)
      end

    end
  end
end