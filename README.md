JSound: a Ruby wrapper for Java's sound API
===========================================

This library requires [JRuby](http://jruby.org)
and currently only supports the [MIDI API](http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/package-summary.html)



Project Info
------------

Home:     http://github.com/adamjmurray/jsound

Author:   Adam Murray (adam@compusition.com)

License:  Distributed under the MIT license, see license.txt



Getting started
---------------

0. Install a recent version of JRuby, either:
   - via manual installation
      - Download and unpack the [current binary version of JRuby](http://jruby.org/download)
      - Put the JRuby bin folder on your PATH
   - or via [rvm](https://rvm.beginrescueend.com/) (adjust the JRuby version number as desired):

             rvm install jruby-1.6.2
             rvm use jruby-1.6.2

0. Download this project, either:
   - via the download link on [this project's github page](http://github.com/adamjmurray/jsound)
   - or via git:

             git clone http://github.com/adamjmurray/jsound.git
             cd jsound

0. Try the examples (monitor.rb prints any input it receives, try playing a MIDI keyboard):

         jruby examples/list_devices.rb
         jruby examples/monitor.rb
     
0. Take a look at the comments in examples/notes.rb for info on:
   - routing MIDI inputs to MIDI outputs
   - generating MIDI events and sending them to an output



Notes
-----

### OS X ###

By enabling the IAC (inter-application communication) driver, you can easily interface with any MIDI-enabled application:

0. Run to /Applications/Utilities/Audio MIDI Setup

0. In the menu, select: Window &rarr; Show MIDI Window

0. Double click IAC Driver

0. Check the box where it says "Device is online"

Now JSound should be able to locate an "IAC Driver" input and output device.

You can also add additional MIDI ports here, to work with multiple applications simultaneously.



Development Notes
-----------------

### Run Tests ###

     rake spec

and to quickly check compatibility with multiple JRuby versions via rvm:

     rvm jruby-1.5.6,jruby-1.6.2 rake spec:fast


### Generate Docs ###

     yard
     open doc/frames.html
