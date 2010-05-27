JSound: a Ruby wrapper for Java's sound API
===========================================

This library requires [JRuby](http://jruby.org)
and currently only supports the [MIDI API](http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/package-summary.html)


Getting started
---------------

Download and unpack [the current release binary of JRuby](http://jruby.org/download) 

Put JRuby's bin folder on your PATH

Download this project (github.com has a download link if you don't have git installed):

     git clone git@github.com:adamjmurray/jsound.git
     
     cd jsound

Try the examples:

     jruby examples/list_devices.rb
     
     jruby examples/monitor.rb
     
Take a look at the comments in examples/notes.rb for some notes on:

* routing MIDI inputs to MIDI outputs

* generating MIDI events and send them to an output


Project Info
------------

http://github.com/adamjmurray/jsound

Author: Adam Murray (adam@compusition.com)

Distributed under the MIT license, see license.txt