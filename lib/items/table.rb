class Table < Item
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/structures/table.png")
    @image.color = "brown"
  end

  def x=(x)
    @x = x
    @image.x = x * PIXELS_PER_SQUARE
  end

  def y=(y)
    @y = y
    @image.y = y * PIXELS_PER_SQUARE
  end

  def category
    :furniture
  end

  def remove
    @image.remove
  end

  def render
    @image.add
  end

  def impassable?
    true
  end

  def type
    :table
  end
end
