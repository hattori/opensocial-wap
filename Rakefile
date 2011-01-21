require 'bundler'
require 'rubygems'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*.rb'
  t.rspec_opts = '--format documentation'
  t.rcov_opts =  %q[--exclude "spec"]
  t.rcov = false
end



task :default => 'spec'
