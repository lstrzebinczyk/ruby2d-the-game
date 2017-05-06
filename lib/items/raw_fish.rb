class RawFish < Item
  def initialize(x, y)
    @x, @y = x, y

    @image = Image.new(
      x * PIXELS_PER_SQUARE,
      y * PIXELS_PER_SQUARE,
      "assets/nature/fish.png",
      z_index
    )
    @image.color = "blue"
  end

  def inspect
    "Raw fish"
  end

  def category
    :material
  end
end
