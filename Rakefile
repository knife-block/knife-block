#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'


desc "Run Unit Tests"
Rake::TestTask.new("unit_tests") do |t|
    t.pattern = "test/unit/*_test.rb"
    t.verbose = true
    t.warning = true
end
