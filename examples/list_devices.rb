#!/usr/bin/env jruby
begin
$: << File.dirname(__FILE__)+'/../lib'
require 'jsound'
include JSound::Midi

puts DEVICES
  
rescue
  puts $!
end
