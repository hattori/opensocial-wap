require 'bundler'
require 'rubygems'
require 'rspec/core/rake_task'

require 'rake'
require 'rake/testtask'

Bundler::GemHelper.install_tasks

Rake::TestTask.new do |test|
  test.libs << "test"
  test.test_files = FileList['test/*test*.rb']
  test.verbose = true
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*.rb'
  t.rspec_opts = '--format documentation'
  t.rcov_opts =  %q[--exclude "spec"]
  t.rcov = false
end



task :default => 'spec'
