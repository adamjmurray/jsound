# A collection of MIDI devices
# Provides methods to locate specific devices

module JSound::Midi::Devices
  class DeviceCollection
    include JSound::Util      

    def initialize
      @coll = []
    end  

    # List all attribute values for the given attribute
    def list_all(attribute=:description)
      @coll.collect{|device| device[attribute]}
    end

    # List attribute values for the given attribute, omitting any unknown values
    def list(attribute=:description)
      list_all(attribute).delete_if{|value| value =~ unknown? }
    end

    def find(criteria)
      search :find, criteria
    end

    def find_all(criteria)
      search :find_all, criteria
    end

    def [](criteria)
      if criteria.kind_of? Fixnum or criteria.kind_of? Range
        @coll[criteria]
      else
        find_all(criteria)
      end
    end

    def /(regexp)
      regexp = Regexp.new(regexp.to_s) if not regexp.kind_of? Regexp
      find(regexp)
    end

    def to_s
      s = "["
      for device in @coll
        s += "," if s.length > 1
        s += "\n#{device.to_s('  ')}"
      end
      s += "\n]"
    end

    private

    def search(iterator, criteria)
      field, target_value = field_and_target_value_for(criteria)
      matcher = matcher_for(target_value)
      @coll.send(iterator) do |device|        
        device[field].send(matcher, target_value)
      end
    end

    def field_and_target_value_for(criteria)
      if criteria.respond_to? :[] and criteria.respond_to? :keys
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
      @coll.send(sym, *args, &block)
    end
          
  end 
end