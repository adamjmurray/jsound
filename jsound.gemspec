Gem::Specification.new do |gem|
  gem.name        = 'jsound'
  gem.version     = '0.0.1'

  gem.summary     = 'Ruby wrapper for the Java sound API'
  gem.author      = 'Adam Murray'
  gem.email       = 'adam@compusition.com'
  gem.homepage    = 'http://github.com/adamjmurray/jsound'

  gem.files = Dir['Rakefile', 'README.md', 'LICENSE.txt', '.yardopts',
                  'lib/**/*', 'spec/**/*', 'examples/**/*']
end