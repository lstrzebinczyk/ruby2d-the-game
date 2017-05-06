class Item
  attr_reader :x, :y

  def x=(x)
    @x = x
    @image.x = x * PIXELS_PER_SQUARE
  end

  def y=(y)
    @y = y
    @image.y = y * PIXELS_PER_SQUARE
  end

  def remove
    @image.remove
  end

  def render
    @image.add
  end

  def z_index
    ZIndex::ITEM
  end
end
