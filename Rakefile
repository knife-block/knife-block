#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'
require 'rubocop/rake_task'

desc "Run rubocop"
task :rubocop do
  RuboCop::RakeTask.new
end

desc "Run Unit Tests"
Rake::TestTask.new("default") do |t|
    t.pattern = "test/unit/*_test.rb"
    t.verbose = true
    t.warning = true
end
