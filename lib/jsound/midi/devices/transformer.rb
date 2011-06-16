module JSound
  module Midi
    module Devices

      class Transformer < Device

        # The transformation block: a lambda that takes a message and returns
        # either a transformed message or an Enumerable list of messages
        attr_accessor :message_processor

        def initialize(&message_processor)
          @message_processor = message_processor
        end

        def message(message)
          if @output and @message_processor
            transformed_message = @message_processor.call(message)
            if transformed_message.is_a? Enumerable
              transformed_message.each{|m| @output.message(m) }
            else
              @output.message(transformed_message) if transformed_message
            end
          end
        end

      end

    end
  end
end
