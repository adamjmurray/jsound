# Since this is a JRuby-based project, run this Rakefile with: jruby -S rake
require 'rspec/core/rake_task'

task :default => :spec

Spec::Rake::SpecTask.new do |t| 
  t.spec_opts = ['--color', '--format', 'nested'] 
end 
