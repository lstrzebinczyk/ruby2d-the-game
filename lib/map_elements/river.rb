class River
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @image = MapRenderer.image(x, y, "assets/nature/river.png", ZIndex::GROUND_OBJECT)
  end

  def passable?
    false
  end
end
