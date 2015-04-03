#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'

desc 'Run rubocop'
task :rubocop do
  puts 'Running Rubocop checks'
  RuboCop::RakeTask.new
  puts 'Rubocop Finished'
  puts '==============='
end

desc 'Run Unit Tests'
puts 'Running Unit Tests'
Rake::TestTask.new('default') do |t|
  t.pattern = 'test/unit/*_test.rb'
  t.verbose = true
  t.warning = true
  puts 'Unit Tests finished'
  puts '==================='
end
