module JSound
  module Midi

    # A collection of MIDI {Device}s that provides various methods to lookup (and optionally auto-open) specific devices
    #
    # @see Midi the Midi module for constants to access your system devices
    #
    class DeviceList

      # The devices within this collection.
      attr_reader :devices

      def initialize(list=[])
        @devices = list
      end

      # Find the first {Device} matching the criteria
      #
      # @param criteria  matches description against for a Regexp argument, matches the device field against the value for a Hash argument, otherwise checks for an equal description
      # @return [Device] the first matching {Device} or nil if nothing matched
      # @note I/O devices need to be opened before they can be used (see {Device#open})
      # @see #find_all
      # @see #open
      # @example {OUTPUTS}.find "IAC Driver Bus 1"  #=> find the first output with the exact description "IAC Driver Bus 1"
      # @example {OUTPUTS}.find /IAC/  #=> find the first output with a description containing "IAC"
      # @example {OUTPUTS}.find :vendor => "Apple Inc."  #=> find the first output with the exact vendor field "Apple Inc."
      # @example {OUTPUTS}.find :vendor => /Apple /  #=> find the first output with a vendor field containing "Apple"
      #
      def find(criteria)
        search :find, criteria
      end

      # Find all {Device}s matching the criteria
      #
      # @param criteria  matches description against for a Regexp argument, matches the device field against the value for a Hash argument, otherwise checks for an equal description
      # @return [Array] an Array of all matching {Device}s or [] if nothing matched
      # @note I/O devices need to be opened before they can be used (see {Device#open})
      # @see #find for examples
      # @see #open
      #
      def find_all(criteria)
        search :find_all, criteria
      end

      # Acts like Array#[] for Numeric and Range arguments. Otherwise acts like {#find_all}.
      #
      # @see #find_all
      #
      def [](criteria)
        if criteria.kind_of? Fixnum or criteria.kind_of? Range
          @devices[criteria]
        else
          find_all(criteria)
        end
      end

      # Find the first device matching the argument and open it.
      #
      # @param device matches description against for a Regexp argument, matches the device field against the value for a Hash argument, otherwise checks for an equal description
      # @return [Device] the device
      # @raise an error if no device can be found
      # @see #find
      # @see #find_all
      #
      def open(device)
        device = find device unless device.is_a? Device
        if device
          device.open
        else
          raise "Device note found: #{device}"
        end
        device
      end

      # Find and open the first device with a description matching the argument.
      #
      # @return [Device] the device
      # @raise an error if no device can be found
      # @see #open
      #
      def /(regexp)
        regexp = Regexp.new(regexp.to_s, Regexp::IGNORECASE) if not regexp.kind_of? Regexp
        open regexp
      end

      # open the first device in this list
      #
      # @return [Device] the device
      # @raise an error if no device can be found
      # @see #open
      #
      def open_first
        open @devices.first
      end

      # open and return the last device in this list
      #
      # @return [Device] the device
      # @raise an error if no device can be found
      # @see #open
      #
      def open_last
        open @devices.first
      end

      def to_s
        @devices.join("\n")
      end

      ########################
      private

      def search(iterator, criteria)
        field, target_value = field_and_target_value_for(criteria)
        matcher = matcher_for(target_value)
        @devices.send(iterator) do |device|
          device.send(field).send(matcher, target_value)
        end
      end

      def field_and_target_value_for(criteria)
        if criteria.is_a? Hash
          first_key = criteria.keys.first
          return first_key, criteria[first_key]
        else
          return :description, criteria
        end
      end

      def matcher_for(target_value)
        case target_value
        when Regexp then '=~'
        else '=='
        end
      end

      # Pass method calls through to the underlying Array.
      # If Array doesn't understand the method, call {#open} with a case-insensitive regexp match
      # against description, treating underscore as a wildcard.
      #
      # @example # {INPUTS}.Akai => open the first "Akai" input device connected to this computer
      # @example # {INPUTS}.Akai_2 => open an input device matching /Akai.*2/i
      #
      def method_missing(sym, *args, &block)
        if @devices.respond_to? sym
          @devices.send(sym, *args, &block)
        elsif args.length == 0 and block.nil?
          self.open /#{sym.to_s.sub '_','.*'}/i
        else
          super
        end
      end

    end

  end
end