Gem::Specification.new do |spec|
  spec.name        = 'jsound'
  spec.version     = '0.1.2'

  spec.summary     = 'Ruby wrapper for the Java sound API'
  spec.description = "A Ruby interface for Java's javax.sound API. Runs on the JVM via JRuby."

  spec.author      = 'Adam Murray'
  spec.email       = 'adam@compusition.com'
  spec.homepage    = 'http://github.com/adamjmurray/jsound'
  spec.license     = 'BSD'

  spec.files = Dir['*.md', '*.txt', 'Rakefile', '.yardopts',
                   'lib/**/*', 'spec/**/*', 'examples/**/*']

  spec.platform    = 'java'
  spec.requirements << "JRuby 1.5+"
  spec.post_install_message = "NOTE: this gem requires JRuby 1.5+"
end