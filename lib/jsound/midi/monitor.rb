module JSound
  
  module Midi
    
    class Monitor
      include_package 'javax.sound.midi'
      include javax.sound.midi.Receiver
        
      def send(java_message, timestamp)
        message = Message.new(java_message) 
        puts "channel #{message.channel} received #{message.type} (#{message.value.inspect})"
      end

    end
    
  end
end