require_relative "./lib/runner.rb"
require "minitest/test_task"
require 'pry'
require 'pry-byebug'

desc "Run Game of Life in console with some defaults"
task :console do
  Runner.new.run(ticks: 200, sleep_time: 0.05)
end

desc "Start new Game of Life creating contributions on GitHub"
task :start do
  runner = Runner.new(printer: ContribPrinter.new)
  runner.tick(times: rand(100))
  runner.print_current_state
end

desc "Run step of GoL from existing GH repo"
task :step do
  # TODO: Implement starting from existing execution in Runner API
  data = GitService.new.get_current_data
  contributions_printer = ContribPrinter.new

  game = GameOfLife.new
  game.fill_from_data(data)
  game.tick

  contributions_printer.clear_display
  contributions_printer.print(game.data)
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
