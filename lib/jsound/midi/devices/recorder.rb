module JSound
  module Midi
    module Devices

      # A Device that records incoming messages, and the timestamp at which they were received.
      class Recorder < Device

        # The recorded [message,timestamp] pairs.
        #
        # Timestamps are in floating point seconds.
        attr_reader :messages_with_timestamps

        # The recorded messages without timestamps
        def messages
          @messages_with_timestamps.map{|m,t| m }
        end

        def initialize(autostart=true)
          clear
          if autostart
            start
          else
            stop
          end
        end

        # clear any recorded messages
        def clear
          @messages_with_timestamps = []
        end

        # start recording
        def open
          @recording = true
        end
        alias start open

        # stop recording
        def close
          @recording = false
        end
        alias stop close

        # true if this object is currently recording
        def open?
          @recording
        end
        alias recording? open?

        def output= device
          raise "#{self.class} cannot be assigned an output"
        end

        def message(message)
          @messages_with_timestamps << [message, Time.now.to_f] if recording?
        end

      end

    end
  end
end