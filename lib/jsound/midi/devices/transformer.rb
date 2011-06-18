module JSound
  module Midi
    module Devices

      class Transformer < Device

        # A Hash of mappings, with entries in the format {:message_attribute => lambda{|attribute| ... } }
        attr_accessor :mappings

        # If true, messages will be automatically cloned when received by this device.
        # Messages are mutable, so in many cases it's important to clone a message before changing it.
        attr_accessor :clone
        
        # The transformation block: a lambda that takes a message and returns
        # either a transformed message or an Enumerable list of messages
        attr_accessor :transform

        # @param mappings [Hash] a Hash of mappings (see {#mappings}).
        #          When not nil, {#clone} will be automatically set to true.
        #          Set {#clone} to false by including the entry \{:clone => false}
        # @param &transform see {#transform}
        def initialize(mappings=nil, &transform)
          @clone = !!mappings.fetch(:clone, true) if mappings
          mappings.delete :clone if mappings
          @mappings = mappings
          @transform = transform
        end

        def message(message)
          message = message.clone if @clone

          for attr, mapping in @mappings
            setter = "#{attr}="
            message.send setter, mapping[message.send attr] if message.respond_to? attr and message.respond_to? setter
          end if @mappings

          if @output
            if @transform
              message = @transform[message]
              if message.is_a? Enumerable
                message.each{|m| @output.message(m) }
              else
                @output.message(message) if message
              end

            elsif @clone or !@transforms.empty?
              @output.message(message)
            end
          end
        end

      end

    end
  end
end
