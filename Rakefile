require "minitest/test_task"
require "./app.rb"
require 'pry'
require 'pry-byebug'

desc "Run Game of Life in console with some defaults"
task :console do
  App.new.run(ticks: 200, sleep_time: 0.05)
end

desc "Run Game of Life mocking GH contributions in console"
task :run do
  runner = App.new(printer: ContribPrinter.new(shade: true))
  10.times { runner.game.tick }
  runner.print_current_state
end

namespace :git do
  desc "demo call"
  task :demo do
    ContribPrinter.new.demo
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
