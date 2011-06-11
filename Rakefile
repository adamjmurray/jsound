require 'rspec/core/rake_task'
require 'rake/clean'

task :default => :spec

CLEAN.include('doc') # clean and clobber do the same thing for now


desc "Run RSpec tests with full output"
RSpec::Core::RakeTask.new do |spec|
  spec.rspec_opts = ["--color", "--format", "nested"]
end

namespace :spec do
  desc "Run RSpecs tests with summary output and fast failure"
  RSpec::Core::RakeTask.new(:fast) do |spec|
    spec.rspec_opts = ["--color", "--fail-fast"]
  end
end