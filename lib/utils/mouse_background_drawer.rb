class MouseBackgroundDrawer
  def initialize
    @image = Square.new(0, 0, PIXELS_PER_SQUARE, [1, 1, 1, 0.2])
  end

  def rerender(x, y)
    if @image.x != x || @image.y != y
      @image.remove
      @image.x = x * PIXELS_PER_SQUARE
      @image.y = y * PIXELS_PER_SQUARE
      @image.add
    end
  end
end
