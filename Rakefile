require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'rake/extensiontask'
require 'yard'

RSpec::Core::RakeTask.new(:spec) do
  system("rake compile")
  system("rake yard")
end

Rake::ExtensionTask.new "cache" do |ext|
  ext.lib_dir = "lib/cache"
end

Rake::ExtensionTask.new "symbols" do |ext|
  ext.lib_dir = "lib/symbols"
end

task :default => :spec

YARD::Rake::YardocTask.new do |t|
 t.files   = ['lib/**/*.rb', 'ext/**/*.c']   # optional
 t.stats_options = ['--list-undoc']         # optional
end
