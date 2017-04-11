# Log is thought of as a 2 meter long, almost 1 meter wide piece of wood
# That is produced by cutting a tree
class Log < Item
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/log.png")
    @image.color = "brown"
  end

  def x=(x)
    @x = x
    @image.x = x * PIXELS_PER_SQUARE
  end

  def y=(y)
    @y = y
    @image.y = y * PIXELS_PER_SQUARE
  end

  def category
    :material
  end

  def remove
    @image.remove
  end

  def render
    @image.add
  end

  def type
    :log
  end
end
