require 'bundler'
require 'rubygems'
require 'rake'
require 'rake/testtask'
Bundler::GemHelper.install_tasks

Rake::TestTask.new do |test|
  test.libs << "test"
  test.test_files = FileList['test/*test*.rb']
  test.verbose = true
end

task :default => 'test'
