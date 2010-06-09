# Common utilities

module JSound  
  module Util
  
    # A regexp matcher for unknown device attributes
    def unknown?
      # I'm not sure if this pattern should change based on locale.
      # It seems stupid that the device info would always returns an "Unknown _____" string when 
      # it doesn't have a value for the field, so I guess this won't work in a non-English locale.
      /^Unknown/
    end
  
    # Escape single quotes
    def escape(s)
      s.gsub("'","\\\\'")
    end
  
  end
end

#------------------------------------------------------------------------------------------
# A mixin for Classes that want a default type() implementation based on the Class name

module JSound::TypeFromClassName
  
  def self.included(base) 
    base.extend(ClassMethods) 
  end 

  module ClassMethods 
    def type
      # Extract class name (from fully qualified Module::Class string) 
      # and convert to camelcase. 
      # For example, JSound::Midi::Messages::NoteOn => 'note_on'     
      name.split('::').last.gsub(/(.)([A-Z])/,'\1_\2').downcase.to_sym
    end
  end

end