require_relative "app.rb"
require_relative 'lib/game_of_life.rb'
require_relative 'lib/git_service.rb'
require "minitest/test_task"
require 'pry'
require 'pry-byebug'

desc "Run Game of Life in console with some defaults"
task :console do
  App.new.run(ticks: 200, sleep_time: 0.05)
end

# Initialize

# Run tick

# Clear it all

desc "Run Game of Life creating contributions in console"
task :run do
  runner = App.new(printer: ContribPrinter.new)
  10.times { runner.game.tick }
  runner.print_current_state
end

desc "Run step of GoL from existing GH repo"
task :step do
  data = GitService.new.get_current_data

  printer = ConsolePrinter.new
  printer.print(data)

  game = GameOfLife.new
  game.fill_from_data(data)

  5.times { game.tick }
  printer.print(game.data)

  # printer = ContribPrinter.new
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
