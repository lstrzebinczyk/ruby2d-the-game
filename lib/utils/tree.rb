class Tree
  def initialize(x, y)
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/pinetree.png")
  end

  def rerender
    @image.remove
    @image.add
  end
end
