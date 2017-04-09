class Table < Item
  attr_reader :x, :y, :count

  def initialize(x, y)
    @x, @y = x, y
    @image = Square.new(
      x * PIXELS_PER_SQUARE + 2,
      y * PIXELS_PER_SQUARE + 2,
      PIXELS_PER_SQUARE - 4,
      "brown"
    )
    # TODO: Picking and storing system must be better thought
    @count = 1
  end

  def remove
    @image.remove
  end

  def can_carry_more?(item_class)
    false
  end

  def get_item
    @count = 0
    self
  end

  def type
    :table
  end

  def picking_time
    5
  end

  def passable?
    false
  end

  def pickable?
    true
  end

  def contains?(item_type)
    false
  end
end
