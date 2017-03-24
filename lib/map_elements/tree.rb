class Tree
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/pinetree.png")
  end

  def passable?
    false
  end

  def rerender
    remove
    @image.add
  end

  def remove
    @image.remove
  end
end