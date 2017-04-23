class Ground
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def remove
  end

  def render
  end

  def passable?
    true
  end
end
