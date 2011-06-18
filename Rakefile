require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'
require File.expand_path('../lib/enlighten/tasks', __FILE__)

desc "Run RSpec"
RSpec::Core::RakeTask.new do |t|
  t.verbose = false
end

task :default => :spec
