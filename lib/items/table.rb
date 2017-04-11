class Table < Item
  def initialize(x, y)
    @x, @y = x, y
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/structures/table.png")
    @image.color = "brown"
  end

  def category
    :furniture
  end

  def impassable?
    true
  end
end
