class Item
  attr_reader :x, :y

  def x=(x)
    @x = x
    @image.x = x
  end

  def y=(y)
    @y = y
    @image.y = y
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
