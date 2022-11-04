class WrappingArray < Array
  def [](index)
    
    res = super(index % size)
    if res.nil?
      puts "Wrapping #{index} to #{index % size}"
    end
    res
  end
end
