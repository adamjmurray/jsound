# A MIDI message
# Subclasses in the Messages module deal with more of the low-level details.
# See http://www.midi.org/techspecs/midimessages.php 
# for details of how the MIDI spec defines these messages.

module JSound
  module Midi

    class Message
      include_package 'javax.sound.midi'

      attr_reader :java_message, :channel, :data
      
      def initialize(type, channel, data, java_message=nil)
        @type = type
        @channel = channel
        @data = data
        @java_message = java_message        
      end
      
      # Maps java message status values to ruby classes
      CLASS_BY_STATUS = {}
      
      def self.inherited(child)
        # I'm using the convention that the message class names
        # correspond to the java ShortMessage constants, like:
        # NoteOn => ShortMessage::NOTE_ON
        status = ShortMessage.const_get(child.type.upcase)
        CLASS_BY_STATUS[status] = child
      end
      
      def self.type
        # Extract class name (from fully qualified Module::Class string) 
        # and convert to camelcase. 
        # For example, JSound::Midi::Messages::NoteOn => 'note_on'     
        name.split('::').last.gsub(/(.)([A-Z])/,'\1_\2').downcase
      end
      
      def type
        # Generic Message objects specify a type explicitly (see initialize)
        # Subclasses will typically use the class type (see self.type)
        @type || self.class.type
      end

      def self.from_java(java_message)
        case java_message
        when SysexMessage
          type = :sysex
          data = java_message.data # this is a byte array in Java, might need conversion?
          
        when MetaMessage  
          type = :meta
          data = java_message.data # this is a byte array in Java, might need conversion?
          
        when ShortMessage
          # For command-type messages, the least significant 4 bits of the status byte will be the channel number.
          # java_message.command will return the desired command's status code in this case, or
          # we can just use a bitmask to grab the most significant 4 bits of the status byte like so:
          status = (java_message.status & 0xF0)
          
          message_class = CLASS_BY_STATUS[status]          
          if message_class
            return message_class.from_java(java_message)
          end
          
          # Old fallback code. Commented out cases have been implemented as classes in the Messages module
          type = case status
          when ShortMessage::ACTIVE_SENSING         then :active_sensing
          # when ShortMessage::CHANNEL_PRESSURE       then :channel_pressure
          when ShortMessage::CONTINUE               then :continue
          # when ShortMessage::CONTROL_CHANGE         then :control_change
          when ShortMessage::END_OF_EXCLUSIVE       then :end_of_exclusive
          when ShortMessage::MIDI_TIME_CODE         then :multi_time_code
          # when ShortMessage::NOTE_OFF               then :note_off
          # when ShortMessage::NOTE_ON                then :note_on
          # when ShortMessage::PITCH_BEND             then :pitch_bend
          # when ShortMessage::POLY_PRESSURE          then :poly_pressure
          # when ShortMessage::PROGRAM_CHANGE         then :program_change
          when ShortMessage::SONG_POSITION_POINTER  then :song_position_pointer
          when ShortMessage::SONG_SELECT            then :song_select
          when ShortMessage::START                  then :start
          when ShortMessage::STOP                   then :stop
          when ShortMessage::SYSTEM_RESET           then :system_reset
          when ShortMessage::TIMING_CLOCK           then :timing_clock
          when ShortMessage::TUNE_REQUEST           then :tune_request
          else :unknown     
          end
          data = [java_message.data1, java_message.data2]
        
        else
          type  = :unknown
          data = nil
        end 
        
        new(type, java_message.channel, data, java_message)
      end
      
      def to_s
        "[#{channel}] #{type}: #{data.inspect}"
      end
      
    end

  end
end