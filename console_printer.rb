class ConsolePrinter
  def initialize()
  end

  def print(data)
    system 'clear'
    buffer = data.map do |row|
      row.map do |cell|
        "#{cell} "
      end.join.strip
    end.join("\n")

    puts buffer
  end
end
