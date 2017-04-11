class Table < Item
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/structures/table.png")
    @image.color = "brown"
  end

  def category
    :furniture
  end

  def remove
    @image.remove
  end

  def can_carry_more?(item_class)
    false
  end

  def type
    :table
  end

  def passable?
    false
  end

  def contains?(item_type)
    item_type == :table
  end
end
