class MouseBackgroundDrawer
  def initialize
    @image = MapRenderer.square(0, 0, 1, [1, 1, 1, 0.2])
    @rendered = true
  end

  def remove
    @image.remove
    @rendered = false
  end

  def render(x, y)
    unless @rendered
      if @image.x != x || @image.y != y
        @image.x = x * PIXELS_PER_SQUARE
        @image.y = y * PIXELS_PER_SQUARE
        @image.add
        @rendered = true
      end
    end
  end
end
