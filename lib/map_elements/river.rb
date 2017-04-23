class River
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @image  = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/river.png")
  end

  def remove
    @image.remove
  end

  def render
    @image.add
  end

  def passable?
    false
  end
end
