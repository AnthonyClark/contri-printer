require './lib/wrapping_array.rb'

class GameOfLife
  attr_accessor :data

  def initialize(rows: 7, cols: 53)
    @rows = rows
    @cols = cols
    @data = data || WrappingArray.new(@rows) { WrappingArray.new(@cols) { 0 } }
  end

  def self.from_data(data)
    rows = data.length
    cols = data[0].length
    game = GameOfLife.new(rows, cols)
    game.fill_from_data(data)
    game
  end

  # TODO: Simplify if we get rid of wrapping array
  def fill_from_data(data)
    @data.each_with_index do |row, i|
      row.each_with_index do |col, j|
        @data[i][j] = data[i][j]
      end
    end
  end

  def randomize
    @data = @data.map do |row|
      row.map do |cell|
        [1, 0].sample
      end
    end
  end

  def add_glider(x, y) # x and y are the coordinates of the center of the glider
    @data[x - 1][y] = 1
    @data[x][y + 1] = 1
    @data[x + 1][y - 1] = 1
    @data[x + 1][y] = 1
    @data[x + 1][y + 1] = 1
  end

  def tick
    new_data = WrappingArray.new(@rows) { WrappingArray.new(@cols) { @off } }
    @data.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        neighbors = 0
        neighbors += @data[r - 1][c - 1]
        neighbors += @data[r - 1][c]
        neighbors += @data[r - 1][c + 1]
        neighbors += @data[r][c - 1]
        neighbors += @data[r][c + 1]
        neighbors += @data[r + 1][c - 1]
        neighbors += @data[r + 1][c]
        neighbors += @data[r + 1][c + 1]

        # compute next state
        new_data[r][c] = if cell == 0 && neighbors == 3
          1
        elsif cell == 1 && (neighbors < 2 || neighbors > 3)
          0
        else
          cell
        end
      end
    end
    @data = new_data
  end
end