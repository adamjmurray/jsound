module JSound::Midi::Messages      
  class NoteOn < Message

    attr_reader :pitch, :velocity

    def initialize(pitch, velocity=127, channel=0, java_message=nil)
      @pitch = pitch
      @velocity = velocity
      @data = {:pitch => pitch, :velocity => velocity}
      @channel = channel
      @java_message = java_message
    end

    def self.from_java(java_message)          
      new(java_message.data1, java_message.data2, java_message.channel, java_message)
    end        

  end      
end