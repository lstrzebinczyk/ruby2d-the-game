class River
  def initialize(x, y)
    @x, @y = x, y
    @image  = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/river.png")
  end

  def rerender
    @image.remove
    @image.add
  end

  def impassable?
    true
  end
end
