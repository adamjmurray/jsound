JSound: a Ruby wrapper for Java's sound API
===========================================

This library requires [JRuby](http://jruby.org)
and currently only supports the [MIDI API](http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/package-summary.html)


Getting started
---------------

Download [JRuby 1.5+ Binary](http://jruby.org/download) and, if desired, put JRuby's bin folder on your PATH

Inside this project's folder, run:

     jruby example.rb
     
Take a look at the comments in example.rb for some things to try, like:

* route a MIDI input to a MIDI output

* monitor a MIDI input by routing it to a JSound::Midi::Monitor


Project Info
------------

Author: Adam Murray (adam@compusition.com)

Distributed under the MIT license, see license.txt