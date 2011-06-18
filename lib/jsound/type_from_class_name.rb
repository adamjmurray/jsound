module JSound

  # Provides a default implementation of .type for the Class, based on the class name.
  module TypeFromClassName

    # Add ClassMethods to the including class.
    def self.included(base) 
      base.extend(ClassMethods) 
    end 

    # Class-level methods added when including TypeFromClassName
    module ClassMethods

      # Extract the class name (from fully qualified Module::Class string)
      # and convert camel case to snake case. 
      # @example JSound::Midi::Messages::NoteOn => :note_on
      def type             
        name.split('::').last.gsub(/(.)([A-Z])/,'\1_\2').downcase.to_sym
      end
    end

  end
end