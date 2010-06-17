# Since this is a JRuby-based project, run this Rakefile with: jruby -S rake
require 'spec/rake/spectask'
require 'rake/rdoctask'

task :default => :spec

Spec::Rake::SpecTask.new do |t| 
  t.spec_opts = ['--color', '--format', 'nested'] 
end 

Rake::RDocTask.new do |t|
  t.main = 'README.rdoc'
  t.rdoc_dir = 'rdoc'
  t.rdoc_files.include(t.main, 'lib/**/*.rb')
end
