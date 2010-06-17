module JSound::Mixins

  # A mixin for Classes that want a default type() implementation based on the Class name.
  # Paricularly useful with the inherited() hook method
  module TypeFromClassName

    # Add ClassMethods to the including class.
    def self.included(base) 
      base.extend(ClassMethods) 
    end 

    # Class-level methods added when including TypeFromClassName
    module ClassMethods
      # Extract the class name (from fully qualified Module::Class string) 
      # and convert camel case to snake case. 
      # For example, JSound::Midi::Messages::NoteOn => 'note_on'      
      def type             
        name.split('::').last.gsub(/(.)([A-Z])/,'\1_\2').downcase.to_sym
      end
    end

  end
end