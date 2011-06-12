module JSound::Midi::Devices

  # A collection of MIDI {Device}s that provides methods to locate specific devices
  class DeviceList
    include JSound::Util

    attr_reader :devices
    
    def initialize(list=[])
      @devices = list
    end  

    # List all attribute values for the given attribute
    def list_all(attribute=:description)
      @devices.collect{|device| device[attribute]}
    end

    # List attribute values for the given attribute, omitting any unknown values
    def list(attribute=:description)
      list_all(attribute).delete_if{|value| value =~ unknown? }
    end

    # Find the first {Device} matching the criteria
    # @param criteria  matches description against for a Regexp argument, matches the device field against the value for a Hash argument, otherwise checks for an equal description
    # @return the first matching {Device} or nil if nothing matched
    def find(criteria)
      search :find, criteria
    end

    # Find all {Device}s matching the criteria
    # @param criteria  matches description against for a Regexp argument, matches the device field against the value for a Hash argument, otherwise checks for an equal description
    # @return an Array of all matching {Device}s or [] if nothing matched
    def find_all(criteria)
      search :find_all, criteria
    end

    # Acts like Array#[] for Numeric and Range arguments
    # Otherwise acts like #find_all
    def [](criteria)
      if criteria.kind_of? Fixnum or criteria.kind_of? Range
        @devices[criteria]
      else
        find_all(criteria)
      end
    end

    # find and open the first device with a description matching the argument
    def /(regexp)
      regexp = Regexp.new(regexp.to_s, Regexp::IGNORECASE) if not regexp.kind_of? Regexp
      device = find(regexp)
      device.open if device
      return device
    end

    def to_s
      @devices.join("\n")
    end

    def to_json(indent='')
      "[\n" + @devices.map{|device| device.to_json(indent+'  ') }.join(",\n") + "\n]"
    end

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

    def method_missing(sym, *args, &block)
      if @devices.respond_to? sym
        @devices.send(sym, *args, &block)
      elsif args.length == 0 and block.nil?
        self / sym
      else
        super
      end
    end
          
  end 
end