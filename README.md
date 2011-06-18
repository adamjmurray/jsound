JSound: a Ruby wrapper for the Java sound API
=============================================

JSound provides cross-platform [MIDI](http://en.wikipedia.org/wiki/Musical_Instrument_Digital_Interface) support for Ruby.

This library requires [JRuby](http://jruby.org).



Project Info
------------

Home:     http://github.com/adamjmurray/jsound

Author:   Adam Murray (adam@compusition.com)

License:  Distributed under a permissive BSD-style license, [see LICENSE.txt](LICENSE.txt)



Getting started
---------------

See [the documentation's introduction](INTRO.md).



Documentation
-------------

Gem: http://rubydoc.info/gems/jsound/0.1.2/frames

Latest for source: http://rubydoc.info/github/adamjmurray/jsound/master/frames



Development Notes
-----------------

### Run Tests ###

     rake spec

and to quickly check compatibility with multiple JRuby versions via rvm:

     rvm jruby-1.5.6,jruby-1.6.2 rake spec:fast


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

* June 18, 2011, version 0.1.2
    - added a "Hash of mappings" feature to Transformer, for easy implementation of simple transformation patterns
    - improved examples
    - got rid of the Repeater device and built its functionality into the base Device
    - added #output= and #>> to DeviceList, to construct parallel paths in device graphs

* June 16, 2011, version 0.1.0
    - first stable release