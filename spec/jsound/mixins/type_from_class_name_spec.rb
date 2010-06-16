#!/usr/bin/env jruby -S spec --format nested
require File.dirname(__FILE__)+'/../../spec_helper'

describe JSound::Mixins::TypeFromClassName do

  context "the including class's type method" do
    
    class IncludingClass
      include JSound::Mixins::TypeFromClassName
    end 
           
    it 'should convert camel case class name to a snake case symbol' do
      IncludingClass.type.should == :including_class
    end
    
    module ContainingModule
      class IncludingClass
        include JSound::Mixins::TypeFromClassName
      end 
    end

    it 'should remove any containing module names' do
      ContainingModule::IncludingClass.type.should == :including_class
    end
    
  end
  
end