class Rectangle
  def contains?(x, y)
    (@x..(@x + @width)).include?(x) && (@y..(@y + @height)).include?(y)
  end
end
