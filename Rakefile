# -*- Ruby -*-
require "bundler/gem_tasks"
require "rake/testtask"

task :default => :test

desc "Run all tests"
task :test do
  ruby "-Ilib test/test_*.rb"
end
