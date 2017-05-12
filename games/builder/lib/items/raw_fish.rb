class RawFish < Item
  def initialize(x, y)
    @x, @y = x, y
    @image = MapRenderer.image(x, y, "assets/nature/fish.png", z_index, "blue")
  end

  def inspect
    "Raw fish"
  end

  def category
    :material
  end
end
