require "minitest/test_task"
require "./app.rb"
require_relative 'lib/github_service.rb'
require 'pry'
require 'pry-byebug'

desc "Run Game of Life in console with some defaults"
task :console do
  App.new.run(ticks: 200, sleep_time: 0.05)
end

desc "Run Game of Life creating contributions in console"
task :run do
  runner = App.new(printer: ContribPrinter.new)
  10.times { runner.game.tick }
  runner.print_current_state
end

desc "Run step of GoL from existing GH repo"
task :step do
  data = GitService.new.get_current_data
  ConsolePrinter.new.print(data)

  # printer = ContribPrinter.new(shade: true)
  # printer.clear_display
  # printer.print(data)
end

namespace :git do
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
