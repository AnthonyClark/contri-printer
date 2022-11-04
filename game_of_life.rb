class GameOfLife
  def initialize(data)
    @data = data
    @rows = @data.size
    @cols = @data.first.size
  end

  def data
    @data
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