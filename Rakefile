require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

Dir.glob(File.join('lib', 'tasks', '**', '*')).each { |f| load f }
