class Character
  def initialize(x, y)
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/characters/woodcutter.png")
  end

  def x
    @image.x / PIXELS_PER_SQUARE
  end

  def y
    @image.y / PIXELS_PER_SQUARE
  end

  def update(x, y)
    @image.remove
    @image.x = x * PIXELS_PER_SQUARE
    @image.y = y * PIXELS_PER_SQUARE
    @image.add
  end

  def rerender
    @image.remove
    @image.add
  end
end
