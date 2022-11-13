class GameOfLife
  attr_accessor :data

  def initialize(rows, cols)
    @rows = rows
    @cols = cols
    @on = 1
    @off = 0
    @data = WrappingArray.new(@rows) { WrappingArray.new(@cols) { @off } }
  end

  # Fill @data with random 1s and 0s
  def randomize
    @data = @data.map do |row|
      row.map do |cell|
        [@on, @off].sample
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
      @data = @data.map.with_index do |row, r|
      row.map.with_index do |cell, c|
        neighbors = 0
        neighbors += @data[r - 1][c - 1] if r > 0 && c > 0
        neighbors += @data[r - 1][c] if r > 0
        neighbors += @data[r - 1][c + 1] if r > 0 && c < @cols - 1
        neighbors += @data[r][c - 1] if c > 0
        neighbors += @data[r][c + 1] if c < @cols - 1
        neighbors += @data[r + 1][c - 1] if r < @rows - 1 && c > 0
        neighbors += @data[r + 1][c] if r < @rows - 1
        neighbors += @data[r + 1][c + 1] if r < @rows - 1 && c < @cols - 1

        # apply rules
        if cell == 0 && neighbors == 3
          1
        elsif cell == 1 && (neighbors < 2 || neighbors > 3)
          0
        else
          cell
        end
      end
    end
  end
end