class ActionPoint
  def initialize(x, y)
    @x = x
    @y = y
    @rendered = Square.new(0, 0, PIXELS_PER_SQUARE, [56.0 / 255, 25.0 / 255, 4.0 / 255, 0.6])
  end

  def update_position(x, y)
    @rendered.remove
    @x = x
    @y = y
    @rendered.x = x
    @rendered.y = y
    @rendered.add
  end
end
