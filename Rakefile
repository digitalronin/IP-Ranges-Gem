require "rubygems/package_task"
require "rdoc/task"
require "rspec"
require "rspec/core/rake_task"
require 'rake/testtask'

$stdout.sync = true

task :default => :spec

task :spec do
  system "bundle exec rspec spec/*_spec.rb spec/**/*_spec.rb"
end

