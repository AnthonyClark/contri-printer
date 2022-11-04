require './console_printer.rb'
require './wrapping_array.rb'
require './game_of_life.rb'

class App
  def initialize
    @rows = 20
    @cols = 52
    @on = 1
    @off = 0
    @printer = ConsolePrinter.new
    data = WrappingArray.new(@rows) { WrappingArray.new(@cols) { [@on, @off].sample } }
    @processor = GameOfLife.new(data)
  end

  def run(ticks, sleep_time)
    ticks.times do
      @processor.tick
      @printer.print(@processor.data)
      sleep sleep_time
    end
  end
end

App.new.run(10, 1)