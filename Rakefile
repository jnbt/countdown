require 'bundler/gem_tasks'
require 'rake/testtask'

desc 'Run tests'
task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end