require "minitest/test_task"
require "./app.rb"
require './lib/contrib_printer.rb'
require 'pry'
require 'pry-byebug'

desc "Run Game of Like in console with some defaults"
task :run do
  App.new.run(200, 0.05)
end

namespace :git do
  desc "Run git test example"
  task :test do
    ContribPrinter.new.push
  end

  desc "Test octokit"
  task :octo do
    ContribPrinter.new.test_octokit
  end

  desc "Delete display github repo"
  task :delete do
    ContribPrinter.new.clear_display
  end
end

Minitest::TestTask.create(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.warning = false
  t.test_globs = ["test/**/*_test.rb"]
end

task :default => :run
