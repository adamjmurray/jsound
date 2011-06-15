require 'spec_helper'

module JSound::Mixins
  describe TypeFromClassName do

    context "including_class#type" do      
      class IncludingClass; include TypeFromClassName end 

      it 'should convert camel case class name to a snake case symbol' do
        IncludingClass.type.should == :including_class
      end

      module ContainingModule
        class IncludingClass
          include TypeFromClassName
        end 
      end

      it 'should remove any containing module names' do
        ContainingModule::IncludingClass.type.should == :including_class
      end

    end

  end
end