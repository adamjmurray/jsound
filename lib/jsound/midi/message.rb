module JSound
  module Midi

    class Message
      include_package 'javax.sound.midi'

      attr_reader :java_message, :channel, :type, :value
      
      def self.note_on(pitch, velocity=127, channel=1)
        m = ShortMessage.new
        m.setMessage(ShortMessage::NOTE_ON, channel, pitch, velocity)
        return self.new(m)
      end
      
      def self.note_off(pitch, velocity=0, channel=1)
        m = ShortMessage.new
        m.setMessage(ShortMessage::NOTE_OFF, channel, pitch, velocity)
        return self.new(m)
      end

      def initialize(message)
        @java_message = message
        @channel = message.channel

        case message
        when SysexMessage
          @type = :sysex
          @value = message.data # this is a byte array in Java, might need conversion?
          
        when MetaMessage  
          @type = :meta
          @value = message.data # this is a byte array in Java, might need conversion?
          
        when ShortMessage
          @type = case message.command
          when ShortMessage::ACTIVE_SENSING         then :active_sensing
          when ShortMessage::CHANNEL_PRESSURE       then :channel_pressure
          when ShortMessage::CONTINUE               then :continue
          when ShortMessage::CONTROL_CHANGE         then :control_change
          when ShortMessage::END_OF_EXCLUSIVE       then :end_of_exclusive
          when ShortMessage::MIDI_TIME_CODE         then :multi_time_code
          when ShortMessage::NOTE_OFF               then :note_off
          when ShortMessage::NOTE_ON                then :note_on
          when ShortMessage::PITCH_BEND             then :pitch_bend
          when ShortMessage::POLY_PRESSURE          then :poly_pressure
          when ShortMessage::PROGRAM_CHANGE         then :program_change
          when ShortMessage::SONG_POSITION_POINTER  then :song_position_pointer
          when ShortMessage::SONG_SELECT            then :song_select
          when ShortMessage::START                  then :start
          when ShortMessage::STOP                   then :stop
          when ShortMessage::SYSTEM_RESET           then :system_reset
          when ShortMessage::TIMING_CLOCK           then :timing_clock
          when ShortMessage::TUNE_REQUEST           then :tune_request
          else :unknown     
          end
          @value = [message.data1, message.data2]
        
        else
          @type  = :unknown
          @value = nil
        end 
      end

    end

  end
end