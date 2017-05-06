class CleanedFish < Item
  def self.required_supplies
    [RawFish]
  end

  def initialize(x, y)
    @x, @y = x, y

    @image = MapRenderer.image(x, y, "assets/nature/fish.png", z_index, "#F3EFE0")
  end

  def inspect
    "Cleaned fish"
  end

  def category
    :material
  end
end
