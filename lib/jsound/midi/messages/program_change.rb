module JSound::Midi::Messages     
  class ProgramChange < Message

    attr_reader :program

    def initialize(program, channel=0, java_message=nil)
      @data = @program = program
      @channel = channel
      @java_message = java_message
    end

    def self.from_java(java_message)          
      new(java_message.data1, java_message.channel, java_message)
    end        

  end      
end