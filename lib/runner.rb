require_relative 'console_printer.rb'
require_relative 'contrib_printer.rb'
require_relative 'game_of_life.rb'

class Runner
  attr_accessor :game

  def initialize(rows: 7, cols: 53, printer: ConsolePrinter.new, game: nil)
    @printer = printer
    if game.nil?
      @game = GameOfLife.new(rows: rows, cols: cols)
      5.times { |i| @game.add_glider(1 + rand(5), 10 * i + 1) }
    else
      @game = game
    end
  end

  def print_current_state
    @printer.print(@game.data)
  end

  def run(ticks: 1, sleep_time: 0)
    ticks.times do
      @game.tick
      @printer.print(@game.data)
      sleep sleep_time
    end
  end

  def tick(times: 1)
    times.times { game.tick }
  end
end
