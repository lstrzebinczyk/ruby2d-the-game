class LogsPile
  def initialize(x, y)
    @x          = x
    @y          = y
    @logs_count = 6
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/logs/6.png")
  end

  def passable?
    true
  end
end
