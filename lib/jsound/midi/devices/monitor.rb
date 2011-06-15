module JSound
  module Midi
    module Devices

      # A device that prints out all incoming MIDI message.
      class Monitor < Device
        def message(message)
          source = message.source
          if source and source.respond_to? :description
            source = "#{source.description} => "
          end
          puts "#{source}#{message}"
        end
      end

    end
  end
end