require "minitest/test_task"
require "./app.rb"
require './lib/contrib_printer.rb'

desc "Run Game of Like in console with some defaults"
task :run do
  App.new.run(200, 0.05)
end

namespace :git do
  desc "Run git example"
  task :run do
    ContribPrinter.new.print
  end

  desc "Clear git repo"
  task :clear do
    ContribPrinter.new.reset_repo
  end
end

Minitest::TestTask.create(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.warning = false
  t.test_globs = ["test/**/*_test.rb"]
end

task :default => :run
