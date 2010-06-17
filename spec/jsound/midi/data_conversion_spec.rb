require 'spec_helper'

module JSound::Midi
  describe DataConversion do

    it 'should define MAX_14BIT_VALUE as the maximum value for 14-bit integers' do
      DataConversion::MAX_14BIT_VALUE.should == (127 + (127 << 7))
    end
    
    context 'with DataConversion included' do      
      include DataConversion

      describe '#to_7bit' do
        it 'should convert positive integers to 7-bit [least_significant,most_significant]' do
          to_7bit(    0).should == [  0,  0]
          to_7bit(    1).should == [  1,  0]
          to_7bit(  127).should == [127,  0]
          to_7bit(  128).should == [  0,  1]
          to_7bit(  129).should == [  1,  1]
          to_7bit(16255).should == [127,126]
          to_7bit(16256).should == [  0,127]
          to_7bit(16257).should == [  1,127]
          to_7bit(16383).should == [127,127]
        end
        it 'should be the inverse of #from_7bit' do
          for lsb in 0..7
            for msb in 0..7
              to_7bit(from_7bit(lsb,msb)).should == [lsb,msb]
            end
          end
        end
      end

      describe '#from_7bit' do
        it 'should convert 7-bit [least_significant,most_significant] to an integer' do
          from_7bit(  0,  0).should ==     0
          from_7bit(  1,  0).should ==     1
          from_7bit(127,  0).should ==   127
          from_7bit(  0,  1).should ==   128
          from_7bit(  1,  1).should ==   129
          from_7bit(127,126).should == 16255
          from_7bit(  0,127).should == 16256
          from_7bit(  1,127).should == 16257
          from_7bit(127,127).should == 16383
        end
        it 'should be the inverse of #to_7bit' do
          for i in 0..16383
            from_7bit(*to_7bit(i)).should == i
          end
        end
      end

      describe '#normalized_float_to_14bit' do
        it 'should scale floats in the range [-1.0, 1.0] to [0, 16383]' do
          normalized_float_to_14bit(-1.0).should ==     0
          normalized_float_to_14bit(-0.5).should ==  4096
          normalized_float_to_14bit( 0.0).should ==  8192
          normalized_float_to_14bit( 0.5).should == 12287
          normalized_float_to_14bit( 1.0).should == 16383
        end
        it 'should convert 1.0 to MAX_14BIT_VALUE' do
          normalized_float_to_14bit(1.0).should == DataConversion::MAX_14BIT_VALUE
        end
      end
    end

  end
end