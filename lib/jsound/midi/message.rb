module JSound
  module Midi

    # A generic MIDI message.
    # The various subclasses in this module deal with specific message details.
    # See http://www.midi.org/techspecs/midimessages.php
    # for info on how the MIDI spec defines these messages.
    class Message
      include JSound::Mixins::TypeFromClassName

      # The MIDI input {Device} which received this message.
      attr_reader :source

      # The variable data for this message type. Contents depend on the message type.
      # @example a NoteOn's #data is [pitch,velocity]
      attr_reader :data

      # The channel number of the message
      attr_reader :channel

      # The type of message, such as :note_on or :control_change
      # @return [Symbol]
      attr_reader :type

      def initialize(data, channel, options={})
        @data = data
        @channel = channel

        # Generic Message objects specify a type explicitly (see initialize).
        # Subclasses will typically use the class type (see JSound::Mixins::TypeFromClassName).
        @type = options[:type] ||= self.class.type

        @java_message = options[:java_message]

        @source = options[:source]
      end

      # Map java message status values to ruby classes
      CLASS_FOR_STATUS = {}

      # Map ruby classes to java message status values
      STATUS_FOR_CLASS = {}

      def self.inherited(child_class)
        # I'm using the convention that the message class names
        # correspond to the java ShortMessage constants, like:
        # NoteOn => ShortMessage::NOTE_ON
        const_name = child_class.type.to_s.upcase
        if javax.sound.midi.ShortMessage.const_defined? const_name
          status = javax.sound.midi.ShortMessage.const_get(const_name)
          CLASS_FOR_STATUS[status] = child_class
          STATUS_FOR_CLASS[child_class] = status
        end
      end

      TYPE_FOR_STATUS = {
        javax.sound.midi.ShortMessage::ACTIVE_SENSING        => :active_sensing,
        javax.sound.midi.ShortMessage::CONTINUE              => :continue,
        javax.sound.midi.ShortMessage::END_OF_EXCLUSIVE      => :end_of_exclusive,
        javax.sound.midi.ShortMessage::MIDI_TIME_CODE        => :multi_time_code,
        javax.sound.midi.ShortMessage::SONG_POSITION_POINTER => :song_position_pointer,
        javax.sound.midi.ShortMessage::SONG_SELECT           => :song_select,
        javax.sound.midi.ShortMessage::START                 => :start,
        javax.sound.midi.ShortMessage::STOP                  => :stop,
        javax.sound.midi.ShortMessage::SYSTEM_RESET          => :system_reset,
        javax.sound.midi.ShortMessage::TIMING_CLOCK          => :timing_clock,
        javax.sound.midi.ShortMessage::TUNE_REQUEST          => :tune_request
      }

      STATUS_FOR_TYPE = TYPE_FOR_STATUS.invert

      # true when the argument has the same {#type}, {#channel}, and {#data}
      def == other
        other.respond_to? :type and type == other.type and
        other.respond_to? :channel and channel == other.channel and
        other.respond_to? :data and data == other.data
      end

      def self.from_java(java_message, options={})
        case java_message
        when javax.sound.midi.SysexMessage
          type = :sysex
          data = java_message.data # this is a byte array in Java, might need conversion?

        when javax.sound.midi.MetaMessage
          type = :meta
          data = java_message.data # this is a byte array in Java, might need conversion?

        when javax.sound.midi.ShortMessage
          # For command-type messages, the least significant 4 bits of the status byte will be the channel number.
          # java_message.command will return the desired command's status code in this case, or
          # we can just use a bitmask to grab the most significant 4 bits of the status byte like so:
          status = (java_message.status & 0xF0)

          message_class = CLASS_FOR_STATUS[status]
          return message_class.from_java(java_message, options) if message_class

          type = TYPE_FOR_STATUS[status] || :unknown
          data = [java_message.data1, java_message.data2]

        else
          type  = :unknown
          data = []
        end

        new data, java_message.channel, options.merge({:type => type, :java_message => java_message})
      end

      def to_java
        if not @java_message
          @java_message = javax.sound.midi.ShortMessage.new
          update_java_message
        end
        # else, since all ruby message classes are backed by "ShortMessage",
        # we should be able to rely on @java_message being set for everything else
        @java_message
      end

      def update_java_message
        @java_message.setMessage(status, @channel, @data[0], @data[1]) if @java_message
      end

      def data= data
        @data = data
        update_java_message
      end

      def data1
        @data[0] if @data
      end

      def data1= data
        @data[0] = data
        update_java_message
      end

      def data2
        @data[1] if @data
      end

      def data2= data
        @data[1] = data
        update_java_message
      end

      def status
        @status ||= (STATUS_FOR_CLASS[self.class] || STATUS_FOR_TYPE[@type])
      end

      def value
        @data
      end

      def to_s
        "#{type}(#{channel}): #{value.inspect}"
      end

    end

  end
end
