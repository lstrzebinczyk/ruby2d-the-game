class MouseBackgroundDrawer
  def initialize
    @image = MapRenderer.square(0, 0, 1, [1, 1, 1, 0.2])
  end

  def remove
    @image.remove
  end

  def add
    @image.add
  end

  def render(x, y)
    @image.x = x
    @image.y = y
  end
end
