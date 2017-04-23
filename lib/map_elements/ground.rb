class Ground
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @grass_eaten_times = 0
  end

  def remove
  end

  def render
  end

  def grass_eaten!
    @grass_eaten_times += 1
    @mask && @mask.remove
    @mask = Square.new(@x * PIXELS_PER_SQUARE, @y * PIXELS_PER_SQUARE, PIXELS_PER_SQUARE, "yellow")
    @mask.color.opacity = 0.09 * @grass_eaten_times
  end

  def passable?
    true
  end
end
