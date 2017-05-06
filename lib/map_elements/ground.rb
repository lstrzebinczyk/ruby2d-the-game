class Ground
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @grass_eaten_times = 0
  end

  def grass_eaten!
    @grass_eaten_times += 1
    @mask && @mask.remove
    @mask = MapRenderer.square(@x, @y, 1, "yellow")
    @mask.color.opacity = 0.09 * @grass_eaten_times
  end

  def passable?
    true
  end
end
