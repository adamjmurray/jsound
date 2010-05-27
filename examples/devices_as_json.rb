#!/usr/bin/env jruby
$: << File.dirname(__FILE__)+'/../lib'
require 'jsound'
include JSound::Midi

puts DEVICES.to_json
