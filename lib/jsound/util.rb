module JSound  

  # Common utilities
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

    # Make all methods be module functions (accessible by sending the method name to module directly)
    instance_methods.each do |method|
      module_function method
    end
  
  end
end

