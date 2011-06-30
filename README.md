JSound: a Ruby wrapper for the Java sound API
=============================================

JSound provides cross-platform [MIDI](http://en.wikipedia.org/wiki/Musical_Instrument_Digital_Interface) support for Ruby.

This library requires [JRuby](http://jruby.org).



Project Info
------------

Home:     http://github.com/adamjmurray/jsound

Author:   Adam Murray (adam@compusition.com)

License:  Distributed under a permissive BSD-style license, see LICENSE.txt



Documentation
-------------

Gem: http://rubydoc.info/gems/jsound/0.1.3/frames

Latest for source: http://rubydoc.info/github/adamjmurray/jsound/master/frames



Development Notes
-----------------

### Run Tests ###

Test with current version of JRuby:

     jruby -S rake spec

Test with all supported versions of JRuby (requires [rvm](https://rvm.beginrescueend.com/), JRuby 1.5.6, and JRuby 1.6.2):

     rake spec:xversion

spec:xversion must pass for a pull request to be accepted or for a release of the jsound gem.


### Generate Docs ###

     yard
     open doc/frames.html

or, to automatically refresh the documentation as you work:

      yard server -r
      open http://localhost:8808


### Project Roadmap ###

https://www.pivotaltracker.com/projects/85719


Changelog
---------

* June 29, 2011, version 0.1.3
    - enhanced JSound::Devices::Recorder to record floating point seconds, instead integer seconds (which wasn't particularly useful)

* June 18, 2011, version 0.1.2
    - added a "Hash of mappings" feature to Transformer, for easy implementation of simple transformation patterns
    - improved examples
    - got rid of the Repeater device and built its functionality into the base Device
    - added #output= and #>> to DeviceList, to construct parallel paths in device graphs

* June 16, 2011, version 0.1.0
    - first stable release