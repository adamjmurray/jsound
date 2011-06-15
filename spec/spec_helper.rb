$: <<  File.dirname(__FILE__)+'/../lib'
require 'jsound'

class MessageMatcher
  def initialize(expected)
    @expected = expected
  end
  def ==(actual) 
    @expected.type == actual.type and
    @expected.channel == actual.channel and
    @expected.data == actual.data
  end 
end 
  
def note_on_message(pitch)
  msg = JSound::Midi::MessageBuilder.note_on(pitch)
  MessageMatcher.new(msg)
end

def note_off_message(pitch)
  msg = JSound::Midi::MessageBuilder.note_off(pitch)
  MessageMatcher.new(msg)
end