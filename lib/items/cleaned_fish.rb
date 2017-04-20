class CleanedFish < Item
  def self.required_supplies
    [RawFish]
  end

  def initialize(x, y)
    @x, @y = x, y

    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/fish.png")
    @image.color = "#F3EFE0"
  end

  def inspect
    "Cleaned fish"
  end

  def category
    :material
  end
end
