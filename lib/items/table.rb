class Table < Item
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @image = Square.new(
      x * PIXELS_PER_SQUARE + 2,
      y * PIXELS_PER_SQUARE + 2,
      PIXELS_PER_SQUARE - 4,
      "brown"
    )
  end

  def type
    :table
  end

  def passable?
    false
  end

  def contains?(item_type)
    false
  end
end
