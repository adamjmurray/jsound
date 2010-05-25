module JSound
  
  module Midi
    
    class Monitor
      include_package 'javax.sound.midi'
      include javax.sound.midi.Receiver
        
      def send(java_message, timestamp)
        message = Message.from_java(java_message) 
        puts message.to_s
      rescue
        STDERR.puts $!
      end

    end
    
  end
end