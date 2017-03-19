class Tree
  def initialize(x, y)
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/pinetree.png")
  end

  def passable?
    false
  end

  def x
    @image.x / PIXELS_PER_SQUARE
  end

  def y
    @image.y / PIXELS_PER_SQUARE
  end

  def rerender
    remove
    @image.add
  end

  def remove
    @image.remove
  end
end
