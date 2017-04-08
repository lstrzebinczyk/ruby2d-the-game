class River
  def initialize(x, y)
    @x, @y = x, y
    @image  = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/river.png")
  end

  def rerender
    @image.remove
    @image.add
  end

  def passable?
    false
  end

  def can_carry_more?(thing)
    false
  end

  def contains?(item_type)
    false
  end
end
