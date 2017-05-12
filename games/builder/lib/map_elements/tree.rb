class Tree
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @image = MapRenderer.image(x, y, "assets/nature/pinetree.png", ZIndex::MAP_ELEMENT)
  end

  def impassable?
    true
  end

  def remove
    @image.remove
  end

  def render
    @image.add
  end
end
