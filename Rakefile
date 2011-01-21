require 'bundler'
require 'rubygems'
#require 'rake'
#require 'rake/testtask'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

#Rake::TestTask.new do |test|
#  test.libs << "test"
#  test.test_files = FileList['test/*test*.rb']
#  test.verbose = true
#end

RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = 'spec/**/*.rb'
  t.rspec_opts = '--format documentation'
  t.rcov_opts =  %q[--exclude "spec"]
  t.rcov = false
end



task :default => 'test'
