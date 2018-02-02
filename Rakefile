require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'rake/extensiontask'

RSpec::Core::RakeTask.new(:spec) do
  %x{rake compile}
end

Rake::ExtensionTask.new "cache" do |ext|
  ext.lib_dir = "lib/cache"
end

task :default => :spec
