class Door < Item
  def self.required_supplies
    [Log]
  end

  def initialize(x, y)
    @x, @y = x, y
    @image = Image.new(
      x * PIXELS_PER_SQUARE,
      y * PIXELS_PER_SQUARE,
      "assets/structures/door.png",
      z_index
    )
    @image.color = "brown"
  end

  def category
    :furniture
  end

  def impassable?
    true
  end
end