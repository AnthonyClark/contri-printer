require './lib/console_printer.rb'
require './lib/contrib_printer.rb'
require './lib/game_of_life.rb'

class App
  attr_accessor :game

  def initialize(rows: 7, cols: 53, printer: ConsolePrinter.new, game: nil)
    @printer = printer
    if game.nil?
      @game = GameOfLife.new(rows, cols)
      5.times { |i| @game.add_glider(1, 10 * i + 1) }
    else
      @game = game
    end
  end

  # initialize new game from file
  def self.github(filename)
    printer = ContribPrinter.new
    printer.commits_to_data
    game = GameOfLife
  end

  def self.from_scratch(rows: 7, cols: 53, printer: ConsolePrinter.new)
    App.new(rows: rows, cols: cols, printer: printer)

  end

  def print_current_state
    @printer.print(@game.data)
  end

  def run(ticks: 1, sleep_time: 1)
    ticks.times do
      @game.tick
      @printer.print(@game.data)
      sleep sleep_time
    end
  end
end
