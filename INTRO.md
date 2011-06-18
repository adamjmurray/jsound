Synopsis
--------

JSound provides cross-platform [MIDI](http://en.wikipedia.org/wiki/Musical_Instrument_Digital_Interface) support for Ruby.

Java's cross-platform standard library includes a
[sound API for MIDI and sampled sound](http://download.oracle.com/javase/tutorial/sound/index.html).
JSound builds on this API and provides a Ruby interface via [JRuby](http://jruby.org).

For now, JSound is focusd on use of the [javax.sound.midi API](http://download.oracle.com/javase/7/docs/api/javax/sound/midi/package-summary.html)
in Ruby scripts and applications.
Support for the [javax.sound.samples API](http://download.oracle.com/javase/7/docs/api/javax/sound/sampled/package-summary.html)
may arrive in the future.

<br>
project info @ http://github.com/adamjmurray/jsound

<br>
Core Concepts
-------------

### Messages ###

Messages repesent musical events, such as a note being played or a musical parameter changing (vibrato, FX level, pitch bend, etc).

JSound provides direct support for various MIDI message, which can be found in the {JSound::Midi::Messages} module.

Generic support for other message types is provided by the {JSound::Midi::Message} class.

<br>
### Devices ###

Devices send messages to one another to communicate musical information. There are 3 general categories:

* __Input Devices__ receive messages from external hardware (e.g. keyboards, digital drums) or other software
* __Output Devices__ send messages to external hardware (e.g. synthesizers) or other software
* __Custom Devices__ process messages in arbitrary ways (e.g. generate, record, transform, route)

JSound provides the input and output devices via the {JSound::Midi::INPUTS} and {JSound::Midi::OUTPUTS} constants.
INPUTS and OUTPUTS are {JSound::Midi::DeviceList}s, which provide methods for looking up specific devices.

You make your own custom devices with Ruby by subclassing the {JSound::Midi::Device} class,
or use some of the custom devices provided in the {JSound::Midi::Devices} module.

<br>
### Device Graphs ###

In order to do something useful, devices must be connected together. Input and Output devices interact with the
outside world but don't do anything useful by themselves. Custom devices have practically unlimited
possibilities, but are useless without input or output.

To connect devices together to form a device graph, we use the {JSound::Midi::Device#>>} operator.

Examples:

record input:
    input >> recorder

generate output:
    generator >> output

transform a MIDI stream:
    input >> transformer >> output


<br>
Using JSound
------------

0. Install JRuby 1.5 or 1.6, either:
   - via manual installation
      - Download and unpack the [current binary version of JRuby](http://jruby.org/download)
      - Put the JRuby bin folder on your PATH
   - or via [rvm](https://rvm.beginrescueend.com/) (adjust version number as desired):

             rvm install jruby-1.6.2
             rvm use jruby-1.6.2

0. Install JSound

         jgem install jsound

0. Try the examples (monitor.rb prints any input it receives, try playing a MIDI keyboard):

         mkdir tmp
         cd tmp
         jgem unpack jsound
         cd jsound-{version}
         jruby examples/list_devices.rb
         jruby examples/monitor.rb
         ...

0. Explore this documentation


<br>
Examples
--------

* {file:examples/list_devices.rb list_devices.rb}

* {file:examples/monitor.rb monitor.rb}

* {file:examples/play_notes.rb play_notes.rb}

* {file:examples/transpose.rb transpose.rb}

* {file:examples/harmonize.rb harmonize.rb}

* {file:examples/harmonize2.rb harmonize2.rb}


 <br>
Notes
-----

### Opening Devices ###

Input and output devices will not function until they are opened via {JSound::Midi::Device#open}.
If an input or output device does not appear to be working, you probably forgot to open it.

Some of the {JSound::Midi::DeviceList} methods will automatically open the device for you.
The {JSound::Midi::DeviceList#method_missing} behavior for DeviceList provides a convenient way to
find and automatically open devices.


<br>
### OS X ###

#### IAC Driver ####
By enabling the IAC (inter-application communication) driver, you can easily interface with any MIDI-enabled application:

0. Run to /Applications/Utilities/Audio MIDI Setup

0. In the menu, select: Window &rarr; Show MIDI Window

0. Double click IAC Driver

0. Check the box where it says "Device is online"

Now JSound should be able to locate an "IAC Driver" input and output device.

You can also add additional MIDI ports here, to work with multiple applications simultaneously.

#### Output ####

OS X does not provide a default MIDI output device, so you will need to take some extra steps to hear anything.

Typically, you'll want to route MIDI to your music production environment (Logic, Reason, Live, etc) using the IAC driver.

If you don't have a music production environment, you can use the free program SimpleSynth as an output:

0. Download SimpleSynth from http://notahat.com/simplesynth

0. Run SimpleSynth

0. Select "SimpleSynth virtual input"

0. Open the SimpleSynth output device in JSound (i.e. Midi::OUTPUTS.SimpleSynth)
