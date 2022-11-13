require './lib/console_printer.rb'
require './lib/game_of_life.rb'

# require 'dotenv/load' TODO

class App
  def initialize
    rows = 7
    cols = 52

    @printer = ConsolePrinter.new
    @game = GameOfLife.new(rows, cols)
    5.times do |i|
      @game.add_glider(1, 10 * i + 1)
    end
    # @printer.print(@game.data)
  end

  def run(ticks, sleep_time)
    ticks.times do
      @game.tick
      @printer.print(@game.data)
      sleep sleep_time
    end
  end
end
